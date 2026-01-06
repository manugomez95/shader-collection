import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const voronoi = {
  name: 'Voronoi',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColor1: { value: [0.0, 0.3, 0.5] },
    uColor2: { value: [0.0, 0.8, 0.7] },
    uScale: { value: 5.0 },
  },
}
