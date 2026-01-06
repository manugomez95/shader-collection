import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const fresnel = {
  name: 'Fresnel',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor: { value: [0.1, 0.1, 0.3] },
    uFresnelColor: { value: [0.3, 0.6, 1.0] },
    uFresnelPower: { value: 3.0 },
  },
}
