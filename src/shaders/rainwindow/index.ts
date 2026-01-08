import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const rainwindow = {
  name: 'Rain Window',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uBackgroundColor1: { value: [0.15, 0.2, 0.35] },
    uBackgroundColor2: { value: [0.05, 0.05, 0.15] },
    uDropSpeed: { value: 0.5 },
    uDropDensity: { value: 1.0 },
  },
}
