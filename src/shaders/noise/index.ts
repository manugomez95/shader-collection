import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const noise = {
  name: 'Noise',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor1: { value: [0.1, 0.1, 0.2] },
    uColor2: { value: [0.8, 0.3, 0.5] },
    uScale: { value: 3.0 },
  },
}
