precision highp float;

uniform float uTime;
uniform vec3 uColor;
uniform vec3 uFresnelColor;
uniform float uFresnelPower;

varying vec3 vNormal;
varying vec3 vViewPosition;

void main() {
  vec3 viewDir = normalize(vViewPosition);
  vec3 normal = normalize(vNormal);

  // Clamp base value for pow() to avoid mobile GPU precision issues
  float base = max(1.0 - abs(dot(viewDir, normal)), 0.001);
  float fresnel = pow(base, uFresnelPower);
  fresnel = fresnel * 0.8 + 0.2 * sin(uTime * 2.0);
  vec3 color = mix(uColor, uFresnelColor, clamp(fresnel, 0.0, 1.0));
  gl_FragColor = vec4(color, 1.0);
}
