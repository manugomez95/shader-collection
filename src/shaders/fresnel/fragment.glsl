uniform float uTime;
uniform vec3 uColor;
uniform vec3 uFresnelColor;
uniform float uFresnelPower;

varying vec3 vNormal;
varying vec3 vViewPosition;

void main() {
  vec3 viewDir = normalize(vViewPosition);
  float fresnel = pow(1.0 - abs(dot(viewDir, vNormal)), uFresnelPower);
  fresnel = fresnel * 0.8 + 0.2 * sin(uTime * 2.0);
  vec3 color = mix(uColor, uFresnelColor, fresnel);
  gl_FragColor = vec4(color, 1.0);
}
