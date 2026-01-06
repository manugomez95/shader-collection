uniform float uTime;

varying vec3 vNormal;
varying vec3 vViewPosition;
varying vec2 vUv;

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec3 viewDir = normalize(vViewPosition);
  float fresnel = pow(1.0 - abs(dot(viewDir, vNormal)), 2.0);

  // Rainbow based on view angle and position
  float hue = fresnel + vUv.y * 0.3 + uTime * 0.2;
  hue += sin(vUv.x * 20.0 + uTime * 3.0) * 0.05;

  vec3 color = hsv2rgb(vec3(hue, 0.7, 0.9));

  // Add scanlines
  float scanline = sin(vUv.y * 100.0 + uTime * 5.0) * 0.1 + 0.9;
  color *= scanline;

  // Boost edge glow
  color += fresnel * 0.3;

  gl_FragColor = vec4(color, 0.9);
}
