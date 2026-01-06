import { useRef, useMemo } from 'react'
import { useFrame } from '@react-three/fiber'
import { Html } from '@react-three/drei'
import * as THREE from 'three'
import type { ShaderConfig } from '../shaders'

interface ShaderSphereProps {
  shader: ShaderConfig
  position: [number, number, number]
}

export function ShaderSphere({ shader, position }: ShaderSphereProps) {
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
  })

  const isTransparent = shader.transparent === true

  return (
    <group position={position}>
      <mesh ref={meshRef}>
        <sphereGeometry args={[0.7, 64, 64]} />
        <shaderMaterial
          vertexShader={shader.vertexShader}
          fragmentShader={shader.fragmentShader}
          uniforms={uniforms}
          transparent={isTransparent}
        />
      </mesh>
      <Html
        position={[0, -1.1, 0]}
        center
        style={{
          color: 'white',
          fontSize: '14px',
          fontFamily: 'system-ui, sans-serif',
          fontWeight: 500,
          textShadow: '0 2px 4px rgba(0,0,0,0.8)',
          whiteSpace: 'nowrap',
          userSelect: 'none',
        }}
      >
        {shader.name}
      </Html>
    </group>
  )
}
