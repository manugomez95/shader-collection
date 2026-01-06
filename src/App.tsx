import { useState } from 'react'
import { ShaderCard } from './components/ShaderCard'
import { ShaderDetail } from './components/ShaderDetail'
import { shaders, type ShaderConfig } from './shaders'

function App() {
  const [selectedShader, setSelectedShader] = useState<ShaderConfig | null>(null)

  if (selectedShader) {
    return (
      <ShaderDetail
        shader={selectedShader}
        onBack={() => setSelectedShader(null)}
      />
    )
  }

  return (
    <div className="app">
      <header>
        <h1>Shader Collection</h1>
        <p>Click on a shader to view details</p>
      </header>
      <div className="gallery">
        {shaders.map((shader) => (
          <ShaderCard
            key={shader.name}
            shader={shader}
            onClick={() => setSelectedShader(shader)}
          />
        ))}
      </div>
    </div>
  )
}

export default App
