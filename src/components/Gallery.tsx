import { ShaderSphere } from './ShaderSphere'
import { shaders } from '../shaders'

export function Gallery() {
  const cols = 5
  const spacingX = 2.2
  const spacingY = 2.8

  return (
    <group>
      {shaders.map((shader, index) => {
        const row = Math.floor(index / cols)
        const col = index % cols

        // Center the grid
        const x = (col - (cols - 1) / 2) * spacingX
        const y = ((1 - row) - 0.5) * spacingY

        return (
          <ShaderSphere
            key={shader.name}
            shader={shader}
            position={[x, y, 0]}
          />
        )
      })}
    </group>
  )
}
