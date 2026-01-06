import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const toon = {
  name: 'Toon',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor: { value: [1.0, 0.4, 0.2] },
    uLightPosition: { value: [5, 5, 5] },
  },
}
