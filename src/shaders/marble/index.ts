import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const marble = {
  name: 'Marble',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor1: { value: [0.9, 0.9, 0.85] },
    uColor2: { value: [0.2, 0.2, 0.25] },
    uScale: { value: 2.0 },
  },
}
