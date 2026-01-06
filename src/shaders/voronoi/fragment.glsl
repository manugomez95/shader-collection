uniform float uTime;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uScale;

varying vec2 vUv;
varying vec3 vPosition;

vec2 random2(vec2 p) {
  return fract(sin(vec2(
    dot(p, vec2(127.1, 311.7)),
    dot(p, vec2(269.5, 183.3))
  )) * 43758.5453);
}

void main() {
  vec2 uv = vUv * uScale;

  vec2 i_st = floor(uv);
  vec2 f_st = fract(uv);

  float m_dist = 1.0;
  vec2 m_point;

  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = random2(i_st + neighbor);

      // Animate
      point = 0.5 + 0.5 * sin(uTime + 6.2831 * point);

      vec2 diff = neighbor + point - f_st;
      float dist = length(diff);

      if (dist < m_dist) {
        m_dist = dist;
        m_point = point;
      }
    }
  }

  vec3 color = mix(uColor1, uColor2, m_dist);

  // Add cell borders
  color -= (1.0 - smoothstep(0.0, 0.05, m_dist)) * 0.3;

  gl_FragColor = vec4(color, 1.0);
}
