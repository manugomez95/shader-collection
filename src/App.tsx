import { ShaderCard } from './components/ShaderCard'
import { shaders } from './shaders'

function App() {
  return (
    <div className="app">
      <header>
        <h1>Shader Collection</h1>
        <p>Drag to rotate each sphere</p>
      </header>
      <div className="gallery">
        {shaders.map((shader) => (
          <ShaderCard key={shader.name} shader={shader} />
        ))}
      </div>
    </div>
  )
}

export default App
