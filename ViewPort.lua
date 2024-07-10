-- **READ-ONLY**
-- FileName: ViewPort3d
-- Written by: Bielsbd
-- 10/7/24

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoverSound = ReplicatedStorage.SoundFolder.Hover
local ClickSound = ReplicatedStorage.SoundFolder.Click
local ButtonClickedEvent = ReplicatedStorage.GUIRemote
local RunService = game:GetService("RunService")

local ViewPortFrame = script.Parent.MainFrame.ScrollingFrame.Content
local template = ReplicatedStorage.Template

local function ApplyHoverEffect(TextButton)
	TextButton.MouseEnter:Connect(function()
		TextButton.UIStroke.Enabled = true
		HoverSound:Play()
	end)
	TextButton.MouseLeave:Connect(function()
		TextButton.UIStroke.Enabled = false
	end)
	TextButton.MouseButton1Click:Connect(function()
		ClickSound:Play()
	end)
end

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

local function Create()
	local existingIcons = {}
	for _, child in pairs(ViewPortFrame:GetChildren()) do
		existingIcons[child.Name] = true
	end

	for _, model in pairs(ReplicatedStorage.Folder:GetChildren()) do
		if not existingIcons[model.Name] then
			local icon = template:Clone()
			icon.Name = model.Name
			icon.Parent = ViewPortFrame

			local content = model:Clone()
			local camera = Instance.new("Camera")
			camera.FieldOfView = 70
			camera.Parent = icon.ViewportFrame
			icon.ViewportFrame.CurrentCamera = camera

			setupViewportContent(content, icon, camera)
			ApplyHoverEffect(icon)

			icon.MouseButton1Click:Connect(function()
				ButtonClickedEvent:FireServer(model.Name)
				print(model.Name .. " button was clicked")
			end)
		end
	end
end

Create()
