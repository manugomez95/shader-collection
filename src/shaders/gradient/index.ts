import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const gradient = {
  name: 'Gradient',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor1: { value: [0.9, 0.2, 0.4] },
    uColor2: { value: [0.9, 0.6, 0.2] },
    uColor3: { value: [0.2, 0.8, 0.9] },
  },
}
