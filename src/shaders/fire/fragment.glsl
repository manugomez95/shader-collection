uniform float uTime;
uniform vec3 uColorBottom;
uniform vec3 uColorMiddle;
uniform vec3 uColorTop;
uniform float uSpeed;
uniform float uIntensity;

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;

// Simplex 2D noise
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy));
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
    + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
    dot(x12.zw, x12.zw)), 0.0);
  m = m*m;
  m = m*m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

// Fractal Brownian Motion for more organic noise
float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for (int i = 0; i < 5; i++) {
    value += amplitude * snoise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return value;
}

void main() {
  // Use spherical coordinates for the fire effect
  vec3 nPos = normalize(vPosition);
  float theta = atan(nPos.x, nPos.z);
  float phi = acos(nPos.y);

  // Create UV coordinates based on spherical position
  vec2 sphereUv = vec2(theta / 3.14159, phi / 3.14159);

  // Height factor - fire rises upward (y-axis on sphere)
  float height = 1.0 - (vPosition.y + 1.0) * 0.5;
  height = clamp(height, 0.0, 1.0);

  // Animated noise for fire turbulence
  float time = uTime * uSpeed;
  vec2 noiseCoord = sphereUv * 4.0;
  noiseCoord.y -= time * 0.5; // Fire rises upward

  // Multiple layers of noise for realistic fire
  float noise1 = fbm(noiseCoord);
  float noise2 = fbm(noiseCoord * 2.0 + vec2(time * 0.3, 0.0));
  float noise3 = snoise(noiseCoord * 3.0 + vec2(0.0, time * 0.7));

  // Combine noise layers
  float fireNoise = noise1 * 0.5 + noise2 * 0.3 + noise3 * 0.2;
  fireNoise = fireNoise * 0.5 + 0.5; // Normalize to 0-1

  // Fire intensity based on height and noise
  float fireIntensity = height * fireNoise * uIntensity;
  fireIntensity = pow(max(fireIntensity, 0.001), 1.5);

  // Add flickering
  float flicker = 0.9 + 0.1 * snoise(vec2(time * 5.0, 0.0));
  fireIntensity *= flicker;

  // Color gradient based on intensity
  vec3 color;
  if (fireIntensity < 0.3) {
    color = mix(vec3(0.0), uColorBottom, fireIntensity / 0.3);
  } else if (fireIntensity < 0.6) {
    color = mix(uColorBottom, uColorMiddle, (fireIntensity - 0.3) / 0.3);
  } else {
    color = mix(uColorMiddle, uColorTop, (fireIntensity - 0.6) / 0.4);
  }

  // Add glow effect
  float glow = fireIntensity * 1.2;
  color += uColorTop * glow * 0.3;

  // Rim lighting for depth
  vec3 viewDir = normalize(cameraPosition - vPosition);
  float rim = 1.0 - max(dot(viewDir, vNormal), 0.0);
  rim = pow(max(rim, 0.001), 2.0);
  color += uColorMiddle * rim * fireIntensity * 0.5;

  gl_FragColor = vec4(color, 1.0);
}
