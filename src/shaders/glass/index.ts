import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const glass = {
  name: 'Glass',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor: { value: [0.4, 0.6, 0.9] },
    uRefractPower: { value: 0.3 },
    uFresnelPower: { value: 2.0 },
  },
  transparent: true,
}
