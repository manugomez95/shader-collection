import { useRef, useMemo, useState } from 'react'
import { Canvas, useFrame } from '@react-three/fiber'
import { OrbitControls } from '@react-three/drei'
import * as THREE from 'three'
import type { ShaderConfig } from '../shaders'

interface ShaderDetailProps {
  shader: ShaderConfig
  onBack: () => void
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

export function ShaderDetail({ shader, onBack }: ShaderDetailProps) {
  const [activeTab, setActiveTab] = useState<'vertex' | 'fragment'>('fragment')

  return (
    <div className="shader-detail">
      <div className="detail-header">
        <button className="back-button" onClick={onBack}>
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M12.5 15L7.5 10L12.5 5" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
          Back to Gallery
        </button>
        <h1>{shader.name} Shader</h1>
      </div>

      <div className="detail-content">
        <div className="preview-section">
          <div className="preview-canvas">
            <Canvas
              camera={{ position: [0, 0, 3], fov: 50 }}
              gl={{ antialias: true, alpha: true }}
            >
              <ambientLight intensity={0.5} />
              <pointLight position={[5, 5, 5]} intensity={1} />
              <pointLight position={[-5, -5, -5]} intensity={0.3} />
              <Sphere shader={shader} />
              <OrbitControls
                enablePan={true}
                enableZoom={true}
                enableRotate={true}
                autoRotate
                autoRotateSpeed={0.5}
              />
            </Canvas>
          </div>
          <p className="preview-hint">Drag to rotate, scroll to zoom</p>
        </div>

        <div className="code-section">
          <div className="code-tabs">
            <button
              className={`code-tab ${activeTab === 'vertex' ? 'active' : ''}`}
              onClick={() => setActiveTab('vertex')}
            >
              Vertex Shader
            </button>
            <button
              className={`code-tab ${activeTab === 'fragment' ? 'active' : ''}`}
              onClick={() => setActiveTab('fragment')}
            >
              Fragment Shader
            </button>
          </div>
          <div className="code-content">
            <pre>
              <code>
                {activeTab === 'vertex' ? shader.vertexShader : shader.fragmentShader}
              </code>
            </pre>
          </div>
        </div>
      </div>
    </div>
  )
}
