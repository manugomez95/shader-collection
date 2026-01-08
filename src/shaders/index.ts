export { fresnel } from './fresnel'
export { toon } from './toon'
export { gradient } from './gradient'
export { glass } from './glass'
export { holographic } from './holographic'
export { noise } from './noise'
export { voronoi } from './voronoi'
export { fractal } from './fractal'
export { plasma } from './plasma'
export { marble } from './marble'
export { rainwindow } from './rainwindow'

import { fresnel } from './fresnel'
import { toon } from './toon'
import { gradient } from './gradient'
import { glass } from './glass'
import { holographic } from './holographic'
import { noise } from './noise'
import { voronoi } from './voronoi'
import { fractal } from './fractal'
import { plasma } from './plasma'
import { marble } from './marble'
import { rainwindow } from './rainwindow'

export interface ShaderConfig {
  name: string
  vertexShader: string
  fragmentShader: string
  uniforms: Record<string, { value: unknown }>
  transparent?: boolean
}

export const shaders: ShaderConfig[] = [
  fresnel,
  toon,
  gradient,
  glass,
  holographic,
  noise,
  voronoi,
  fractal,
  plasma,
  marble,
  rainwindow,
]
