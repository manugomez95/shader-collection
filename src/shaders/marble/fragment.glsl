uniform float uTime;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uScale;

varying vec2 vUv;
varying vec3 vPosition;

// Simple noise function
float hash(vec3 p) {
  p = fract(p * 0.3183099 + 0.1);
  p *= 17.0;
  return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

float noise(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);

  return mix(
    mix(
      mix(hash(i + vec3(0,0,0)), hash(i + vec3(1,0,0)), f.x),
      mix(hash(i + vec3(0,1,0)), hash(i + vec3(1,1,0)), f.x),
      f.y
    ),
    mix(
      mix(hash(i + vec3(0,0,1)), hash(i + vec3(1,0,1)), f.x),
      mix(hash(i + vec3(0,1,1)), hash(i + vec3(1,1,1)), f.x),
      f.y
    ),
    f.z
  );
}

float fbm(vec3 p) {
  float value = 0.0;
  float amplitude = 0.5;
  for (int i = 0; i < 5; i++) {
    value += amplitude * noise(p);
    p *= 2.0;
    amplitude *= 0.5;
  }
  return value;
}

void main() {
  vec3 pos = vPosition * uScale;
  pos.z += uTime * 0.1;

  float n = fbm(pos);
  float marble = sin(pos.x * 5.0 + n * 10.0) * 0.5 + 0.5;

  // Add veins
  float veins = fbm(pos * 3.0 + vec3(uTime * 0.05));
  marble = mix(marble, veins, 0.3);

  vec3 color = mix(uColor1, uColor2, marble);

  // Subtle specular
  float spec = pow(marble, 3.0) * 0.2;
  color += spec;

  gl_FragColor = vec4(color, 1.0);
}
