import { useRef, useMemo } from 'react'
import { Canvas, useFrame } from '@react-three/fiber'
import * as THREE from 'three'
import type { ShaderConfig } from '../shaders'

interface ShaderCardProps {
  shader: ShaderConfig
  onClick?: () => void
}

function Sphere({ shader }: { shader: ShaderConfig }) {
  const meshRef = useRef<THREE.Mesh>(null)

  const uniforms = useMemo(() => {
    const u: Record<string, THREE.IUniform> = {}
    for (const [key, value] of Object.entries(shader.uniforms)) {
      const v = value.value
      if (Array.isArray(v)) {
        if (v.length === 2) {
          u[key] = { value: new THREE.Vector2(v[0] as number, v[1] as number) }
        } else if (v.length === 3) {
          u[key] = { value: new THREE.Vector3(v[0] as number, v[1] as number, v[2] as number) }
        } else {
          u[key] = { value: v }
        }
      } else {
        u[key] = { value: v }
      }
    }
    return u
  }, [shader])

  useFrame((state) => {
    if (uniforms.uTime) {
      uniforms.uTime.value = state.clock.elapsedTime
    }
    // Auto-rotate the mesh
    if (meshRef.current) {
      meshRef.current.rotation.y = state.clock.elapsedTime * 0.5
    }
  })

  const isTransparent = shader.transparent === true

  return (
    <mesh ref={meshRef}>
      <sphereGeometry args={[1.2, 64, 64]} />
      <shaderMaterial
        vertexShader={shader.vertexShader}
        fragmentShader={shader.fragmentShader}
        uniforms={uniforms}
        transparent={isTransparent}
      />
    </mesh>
  )
}

export function ShaderCard({ shader, onClick }: ShaderCardProps) {
  return (
    <div className="shader-card" onClick={onClick}>
      <div className="canvas-container">
        <Canvas
          camera={{ position: [0, 0, 3], fov: 50 }}
          gl={{ antialias: true, alpha: true }}
        >
          <ambientLight intensity={0.5} />
          <pointLight position={[5, 5, 5]} intensity={1} />
          <pointLight position={[-5, -5, -5]} intensity={0.3} />
          <Sphere shader={shader} />
        </Canvas>
      </div>
      <div className="shader-name">{shader.name}</div>
    </div>
  )
}
