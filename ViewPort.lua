-- FileName: ViewPort3DModule
-- Written by: Bielsbd
-- 10/7/24

local ViewPort3DModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Private Variables
local ViewPortFrame
local Template

-- Private Functions
local function setupViewportContent(content, icon, camera)
	content.Parent = icon.ViewportFrame

	local cf, size
	if content:IsA("Model") then
		cf, size = content:GetBoundingBox()
	elseif content:IsA("MeshPart") or content:IsA("Part") then
		cf = content.CFrame
		size = content.Size
	else
		warn("El tipo de asset no es compatible:", content.ClassName)
		return
	end

	local distance = (size.Magnitude / 2) / math.tan(math.rad(camera.FieldOfView / 2))
	camera.CFrame = CFrame.new(cf.Position + Vector3.new(0, 0, distance), cf.Position)

	local theta = 0
	local renderConnection
	renderConnection = RunService.RenderStepped:Connect(function(dt)
		if not icon.Parent then
			renderConnection:Disconnect()
			return
		end
		theta = theta + math.rad(20 * dt)
		camera.CFrame = CFrame.new(cf.Position) * CFrame.fromEulerAnglesYXZ(0, theta, 0) * CFrame.new(0, 0, distance)
	end)
end

-- Public Functions
function ViewPort3DModule.Setup(viewportFrame, template)
	ViewPortFrame = viewportFrame
	Template = template
end

function ViewPort3DModule.Create(folder)
	if not ViewPortFrame or not Template then
		error("ViewPort3DModule.Setup must be called before Create.")
	end

	local existingIcons = {}
	for _, child in pairs(ViewPortFrame:GetChildren()) do
		existingIcons[child.Name] = true
	end

	for _, model in pairs(folder:GetChildren()) do
		if not existingIcons[model.Name] then
			local icon = Template:Clone()
			icon.Name = model.Name
			icon.Parent = ViewPortFrame

			local content = model:Clone()
			local camera = Instance.new("Camera")
			camera.FieldOfView = 70
			camera.Parent = icon.ViewportFrame
			icon.ViewportFrame.CurrentCamera = camera

			setupViewportContent(content, icon, camera)

			icon.MouseButton1Click:Connect(function()
				print(model.Name .. " button was clicked")
			end)
		end
	end
end

return ViewPort3DModule
