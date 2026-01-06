import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const fractal = {
  name: 'Fractal',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uZoom: { value: 1.0 },
    uOffset: { value: [0, 0] },
  },
}
