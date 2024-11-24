# ViewPort3DModule

El modulo sirve para gestionar vistas previas en 3D mediante `ViewportFrame`. 

---

## Cómo usar el módulo

### 1. Cargar el módulo
```lua
local ViewPort3DModule = require(ReplicatedStorage:WaitForChild("ViewPort3DModule"))
```

### 2. Configurar el módulo
```lua
local viewportFrame = script.Parent.MainFrame.ScrollingFrame.Content
local template = ReplicatedStorage.Template

ViewPort3DModule.Setup(viewportFrame, template)
```

### 3. Crear los íconos
```lua
local folder = ReplicatedStorage:WaitForChild("Folder")
ViewPort3DModule.Create(folder)
```
