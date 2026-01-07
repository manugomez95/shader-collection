import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

export const fire = {
  name: 'Fire',
  vertexShader,
  fragmentShader,
  uniforms: {
    uTime: { value: 0 },
    uColorBottom: { value: [0.5, 0.0, 0.0] },    // Dark red
    uColorMiddle: { value: [1.0, 0.3, 0.0] },    // Orange
    uColorTop: { value: [1.0, 0.9, 0.3] },       // Yellow/white
    uSpeed: { value: 1.0 },
    uIntensity: { value: 1.5 },
  },
}
