uniform float uTime;
uniform vec3 uBackgroundColor1;
uniform vec3 uBackgroundColor2;
uniform float uDropSpeed;
uniform float uDropDensity;

varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vViewPosition;

// Random function
float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Smooth noise
float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);

  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Create a single raindrop
float raindrop(vec2 uv, vec2 center, float size) {
  float dist = length(uv - center);

  // Main drop body (ellipse, taller than wide)
  vec2 diff = uv - center;
  float ellipse = length(vec2(diff.x * 1.5, diff.y * 0.8));
  float drop = smoothstep(size, size * 0.3, ellipse);

  // Add tail for running drops
  float tail = smoothstep(0.0, size * 3.0, uv.y - center.y);
  tail *= smoothstep(size * 0.5, 0.0, abs(uv.x - center.x));
  tail *= 0.5;

  return max(drop, tail);
}

// Create rain layer with multiple drops
float rainLayer(vec2 uv, float time, float scale, float speed) {
  float rain = 0.0;

  // Tile the UV space for repeating drops
  vec2 gridUv = uv * scale;
  vec2 gridId = floor(gridUv);
  vec2 gridFract = fract(gridUv);

  // Check neighboring cells for drops that might overlap
  for (float i = -1.0; i <= 1.0; i++) {
    for (float j = -1.0; j <= 1.0; j++) {
      vec2 neighbor = vec2(i, j);
      vec2 cellId = gridId + neighbor;

      // Random offset within cell
      float randX = random(cellId);
      float randY = random(cellId + vec2(100.0, 0.0));
      float randSize = random(cellId + vec2(0.0, 100.0));
      float randSpeed = random(cellId + vec2(200.0, 0.0));

      // Drop position with animation (falling down)
      vec2 dropPos = vec2(randX * 0.8 + 0.1, 0.0);
      dropPos.y = fract(randY - time * speed * (0.5 + randSpeed * 0.5));

      // Offset to cell-local coordinates
      vec2 localPos = gridFract - neighbor;

      // Draw the drop
      float dropSize = 0.08 + randSize * 0.12;
      rain += raindrop(localPos, dropPos, dropSize * uDropDensity);
    }
  }

  return clamp(rain, 0.0, 1.0);
}

// Create streaks (water trails on glass)
float waterStreaks(vec2 uv, float time) {
  float streaks = 0.0;

  for (float i = 0.0; i < 8.0; i++) {
    float offset = random(vec2(i, 0.0)) * 6.28;
    float xPos = random(vec2(i, 1.0));
    float speed = 0.3 + random(vec2(i, 2.0)) * 0.4;

    // Wavy path for streak
    float wave = sin(uv.y * 10.0 + offset + time * speed) * 0.02;
    float streak = smoothstep(0.02, 0.0, abs(uv.x - xPos - wave));

    // Fade based on vertical position (animated)
    float yFade = fract(uv.y + time * speed * 0.5 + random(vec2(i, 3.0)));
    streak *= smoothstep(0.0, 0.3, yFade) * smoothstep(1.0, 0.7, yFade);

    streaks += streak * 0.3;
  }

  return clamp(streaks, 0.0, 1.0);
}

// Create background city lights / bokeh effect
vec3 backgroundScene(vec2 uv, float distortion) {
  vec2 distortedUv = uv + distortion * 0.1;

  // Gradient base
  vec3 color = mix(uBackgroundColor2, uBackgroundColor1, distortedUv.y);

  // Add blurry bokeh lights
  float lights = 0.0;
  for (float i = 0.0; i < 12.0; i++) {
    vec2 lightPos = vec2(
      random(vec2(i, 0.0)),
      random(vec2(i, 1.0)) * 0.7 + 0.1
    );

    float dist = length(distortedUv - lightPos);
    float brightness = random(vec2(i, 2.0)) * 0.5 + 0.5;
    float flicker = sin(uTime * (1.0 + random(vec2(i, 3.0)) * 2.0)) * 0.2 + 0.8;

    // Larger, blurrier circles for bokeh
    lights += smoothstep(0.15, 0.0, dist) * brightness * flicker;
  }

  // Color the lights with warm tones
  vec3 lightColor = vec3(1.0, 0.8, 0.5) * lights * 0.5;
  color += lightColor;

  // Add some blue/purple lights
  for (float i = 0.0; i < 6.0; i++) {
    vec2 lightPos = vec2(
      random(vec2(i + 20.0, 0.0)),
      random(vec2(i + 20.0, 1.0)) * 0.5 + 0.2
    );
    float dist = length(distortedUv - lightPos);
    float brightness = random(vec2(i + 20.0, 2.0));
    color += vec3(0.3, 0.4, 1.0) * smoothstep(0.12, 0.0, dist) * brightness * 0.4;
  }

  return color;
}

void main() {
  vec2 uv = vUv;
  float time = uTime * uDropSpeed;

  // Create multiple rain layers at different scales
  float rain1 = rainLayer(uv, time, 4.0, 1.0);
  float rain2 = rainLayer(uv + vec2(0.3, 0.7), time * 0.8, 6.0, 0.7);
  float rain3 = rainLayer(uv + vec2(0.6, 0.2), time * 1.2, 8.0, 1.3);

  // Combine rain layers
  float rain = rain1 + rain2 * 0.7 + rain3 * 0.5;
  rain = clamp(rain, 0.0, 1.0);

  // Add water streaks
  float streaks = waterStreaks(uv, time);
  float water = clamp(rain + streaks, 0.0, 1.0);

  // Calculate distortion amount based on water
  float distortion = water * 0.3 + noise(uv * 10.0 + time) * 0.05;

  // Get background with distortion
  vec3 background = backgroundScene(uv, distortion);

  // Glass tint
  vec3 glassTint = vec3(0.7, 0.8, 0.9);

  // Fresnel effect for glass
  vec3 viewDir = normalize(vViewPosition);
  float fresnelBase = max(1.0 - abs(dot(viewDir, vNormal)), 0.001);
  float fresnel = pow(fresnelBase, 2.0);

  // Combine elements
  vec3 color = background * glassTint;

  // Add water highlights (refraction simulation)
  color += water * vec3(0.15, 0.2, 0.25);

  // Add fresnel rim glow
  color += fresnel * vec3(0.3, 0.4, 0.5) * 0.5;

  // Add subtle specular on water drops
  vec3 lightDir = normalize(vec3(0.5, 1.0, 0.5));
  vec3 reflectDir = reflect(-lightDir, vNormal);
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), 16.0);
  color += spec * water * 0.4;

  // Slight vignette for depth
  float vignette = 1.0 - length(uv - 0.5) * 0.5;
  color *= vignette;

  gl_FragColor = vec4(color, 1.0);
}
