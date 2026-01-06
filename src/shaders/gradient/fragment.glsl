uniform float uTime;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;

varying vec2 vUv;
varying vec3 vPosition;

void main() {
  float t = vPosition.y * 0.5 + 0.5;
  t += sin(uTime + vPosition.x * 3.0) * 0.1;
  t += cos(uTime * 0.7 + vPosition.z * 2.0) * 0.1;
  t = clamp(t, 0.0, 1.0);

  vec3 color;
  if (t < 0.5) {
    color = mix(uColor1, uColor2, t * 2.0);
  } else {
    color = mix(uColor2, uColor3, (t - 0.5) * 2.0);
  }

  gl_FragColor = vec4(color, 1.0);
}
