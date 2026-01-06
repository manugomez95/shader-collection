uniform float uTime;
uniform float uZoom;
uniform vec2 uOffset;

varying vec2 vUv;

vec3 palette(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.263, 0.416, 0.557);
  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 c = (vUv - 0.5) * 4.0 / uZoom + uOffset;

  // Animate the Julia set parameter
  vec2 z = c;
  float angle = uTime * 0.3;
  vec2 julia = vec2(
    0.7885 * cos(angle),
    0.7885 * sin(angle)
  );

  float iter = 0.0;
  const float maxIter = 100.0;

  for (float i = 0.0; i < maxIter; i++) {
    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + julia;

    if (dot(z, z) > 4.0) {
      iter = i;
      break;
    }
    iter = i;
  }

  float t = iter / maxIter;
  t = sqrt(t);

  vec3 color = palette(t + uTime * 0.1);

  if (iter >= maxIter - 1.0) {
    color = vec3(0.0);
  }

  gl_FragColor = vec4(color, 1.0);
}
