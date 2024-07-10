--[[
	// **READ-ONLY**
	// FileName: ViewPort3d
	// Written by: Bielsbd
  // 10/7/24
--]]

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

local function Create(carPartName, vehicleType)
	local models = ReplicatedStorage.Folder:GetChildren()

	for index, model in pairs(models) do
		-- Verify if a button with the same name already exists
		if not ViewPortFrame:FindFirstChild(model.Name) then
			local icon = template:Clone()
			model = model:Clone()

			local camera = Instance.new("Camera")
			camera.FieldOfView = 70
			camera.Parent = icon.ViewportFrame

			model.Parent = icon.ViewportFrame
			icon.ViewportFrame.CurrentCamera = camera
			icon.Parent = ViewPortFrame
			icon.Name = model.Name

			local vpfModel = ViewportModel.new(icon.ViewportFrame, camera)
			local cf, size = model:GetBoundingBox()

			vpfModel:SetModel(model)

			local theta = 0
			local orientation = CFrame.new()
			local distance = vpfModel:GetFitDistance(cf.Position)

			game:GetService("RunService").RenderStepped:Connect(function(dt)
				theta = theta + math.rad(20 * dt)
				orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), theta, 0)
				camera.CFrame = CFrame.new(cf.Position) * orientation * CFrame.new(0, 0, distance)
			end)

			-- Connect the button event to the RemoteEvent
			icon.MouseButton1Click:Connect(function()
				ButtonClickedEvent:FireServer(model.Name, carPartName)
				print(model.Name .. " button was clicked")
			end)

			-- Apply hover and click effects
			ApplyHoverEffect(icon)
		end
	end
end
