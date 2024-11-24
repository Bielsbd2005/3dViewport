# ViewPort3DModule

Un módulo de Roblox para gestionar vistas previas en 3D mediante `ViewportFrame`. Este módulo permite crear íconos dinámicos que muestran modelos 3D giratorios, organizados en un contenedor de UI.

---

## Cómo usar el módulo

### 1. Cargar el módulo

Primero, asegúrate de requerir el módulo desde `ReplicatedStorage`:

```lua
local ViewPort3DModule = require(ReplicatedStorage:WaitForChild("ViewPort3DModule"))
```

### 2. Configurar el módulo
Configura el contenedor (viewportFrame) donde se mostrarán los íconos, así como el template que define el diseño visual de cada ícono:
```lua
local viewportFrame = script.Parent.MainFrame.ScrollingFrame.Content
local template = ReplicatedStorage.Template
```

ViewPort3DModule.Setup(viewportFrame, template)

### 3. Crear los íconos
Llama a la función Create para generar los íconos dinámicos a partir de los modelos almacenados en una carpeta dentro de ReplicatedStorage:
```lua
local folder = ReplicatedStorage:WaitForChild("Folder")
ViewPort3DModule.Create(folder)
```
