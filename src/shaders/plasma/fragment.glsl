uniform float uTime;
uniform float uScale;

varying vec2 vUv;
varying vec3 vPosition;

void main() {
  vec2 uv = vUv * uScale;
  float t = uTime;

  float v1 = sin(uv.x * 10.0 + t);
  float v2 = sin(10.0 * (uv.x * sin(t / 2.0) + uv.y * cos(t / 3.0)) + t);
  float v3 = sin(sqrt(100.0 * ((uv.x - 0.5) * (uv.x - 0.5) + (uv.y - 0.5) * (uv.y - 0.5)) + 1.0) + t);

  float cx = uv.x + 0.5 * sin(t / 5.0);
  float cy = uv.y + 0.5 * cos(t / 3.0);
  float v4 = sin(sqrt(100.0 * (cx * cx + cy * cy) + 1.0) + t);

  float v = v1 + v2 + v3 + v4;

  vec3 color;
  color.r = sin(v * 3.14159) * 0.5 + 0.5;
  color.g = sin(v * 3.14159 + 2.094) * 0.5 + 0.5;
  color.b = sin(v * 3.14159 + 4.188) * 0.5 + 0.5;

  gl_FragColor = vec4(color, 1.0);
}
