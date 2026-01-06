import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const holographic = {
  name: 'Holographic',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
  },
  transparent: true,
}
