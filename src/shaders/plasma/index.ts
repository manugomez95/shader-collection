import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const plasma = {
  name: 'Plasma',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uScale: { value: 1.0 },
  },
}
