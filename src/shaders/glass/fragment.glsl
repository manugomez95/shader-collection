uniform float uTime;
uniform vec3 uColor;
uniform float uRefractPower;
uniform float uFresnelPower;

varying vec3 vNormal;
varying vec3 vViewPosition;
varying vec3 vWorldPosition;

void main() {
  vec3 viewDir = normalize(vViewPosition);

  // Fresnel effect
  float fresnel = pow(1.0 - abs(dot(viewDir, vNormal)), uFresnelPower);

  // Fake refraction color shift
  vec3 refractColor = uColor;
  refractColor.r += sin(vWorldPosition.x * 10.0 + uTime) * 0.1;
  refractColor.g += sin(vWorldPosition.y * 10.0 + uTime * 1.1) * 0.1;
  refractColor.b += sin(vWorldPosition.z * 10.0 + uTime * 1.2) * 0.1;

  // Specular highlight
  vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
  vec3 reflectDir = reflect(-lightDir, vNormal);
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

  vec3 color = mix(refractColor * 0.3, vec3(1.0), fresnel * 0.5);
  color += spec * 0.5;

  float alpha = 0.6 + fresnel * 0.3;
  gl_FragColor = vec4(color, alpha);
}
