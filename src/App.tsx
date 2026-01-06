import { Canvas } from '@react-three/fiber'
import { OrbitControls } from '@react-three/drei'
import { Gallery } from './components/Gallery'

function App() {
  return (
    <Canvas
      camera={{ position: [0, 0, 10], fov: 50 }}
      gl={{ antialias: true }}
    >
      <color attach="background" args={['#0a0a0a']} />
      <ambientLight intensity={0.5} />
      <pointLight position={[10, 10, 10]} intensity={1} />
      <pointLight position={[-10, -10, -10]} intensity={0.5} />
      <Gallery />
      <OrbitControls
        enablePan={true}
        enableZoom={true}
        enableRotate={true}
        minDistance={5}
        maxDistance={20}
      />
    </Canvas>
  )
}

export default App
