uniform float uTime;
uniform vec3 uColor;
uniform vec3 uLightPosition;

varying vec3 vNormal;
varying vec3 vPosition;

void main() {
  vec3 lightDir = normalize(uLightPosition - vPosition);
  float diff = dot(vNormal, lightDir);

  // Quantize lighting into bands
  float bands = 4.0;
  diff = floor(diff * bands) / bands;
  diff = max(diff, 0.2);

  vec3 color = uColor * diff;

  // Add rim light
  vec3 viewDir = normalize(cameraPosition - vPosition);
  float rim = 1.0 - max(dot(viewDir, vNormal), 0.0);
  rim = smoothstep(0.6, 1.0, rim);
  color += rim * 0.3;

  gl_FragColor = vec4(color, 1.0);
}
