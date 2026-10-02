--==================================================
-- MOBILADOR HUB
-- INTERFAZ + MACRO + FPS BOOST
-- PARA TU PROPIO JUEGO DE ROBLOX
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--==================================================
-- CONFIGURACIÓN
--==================================================

local VELOCIDAD_SACAR = 0.02
local VELOCIDAD_GUARDAR = 0.02

local fpsActivo = false
local macroEnUso = false
local macroActiva = false
local minimizado = false
local maximizado = false

-- NOMBRE EXACTO DE LA PISTOLA
local NOMBRE_PISTOLA = "Pistol"

local originales = {}

--==================================================
-- GUI PRINCIPAL
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "MobiladorHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local ventana = Instance.new("Frame")
ventana.Name = "Ventana"
ventana.Size = UDim2.new(0, 430, 0, 300)
ventana.Position = UDim2.new(0.5, -215, 0.5, -150)
ventana.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ventana.BorderSizePixel = 0
ventana.Parent = gui

local esquina = Instance.new("UICorner")
esquina.CornerRadius = UDim.new(0, 10)
esquina.Parent = ventana

--==================================================
-- BARRA SUPERIOR
--==================================================

local barra = Instance.new("Frame")
barra.Name = "Barra"
barra.Size = UDim2.new(1, 0, 0, 50)
barra.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
barra.BorderSizePixel = 0
barra.Parent = ventana

local movilador = Instance.new("TextLabel")
movilador.BackgroundTransparency = 1
movilador.Position = UDim2.new(0, 15, 0, 0)
movilador.Size = UDim2.new(0, 150, 1, 0)
movilador.Font = Enum.Font.GothamBold
movilador.Text = "MOBILADOR"
movilador.TextColor3 = Color3.fromRGB(0, 120, 255)
movilador.TextSize = 22
movilador.TextXAlignment = Enum.TextXAlignment.Left
movilador.Parent = barra

local hubTexto = Instance.new("TextLabel")
hubTexto.BackgroundTransparency = 1
hubTexto.Position = UDim2.new(0, 150, 0, 0)
hubTexto.Size = UDim2.new(0, 70, 1, 0)
hubTexto.Font = Enum.Font.GothamBold
hubTexto.Text = "HUB"
hubTexto.TextColor3 = Color3.fromRGB(255, 40, 40)
hubTexto.TextSize = 22
hubTexto.TextXAlignment = Enum.TextXAlignment.Left
hubTexto.Parent = barra

--==================================================
-- BOTONES SUPERIORES
--==================================================

local minimizar = Instance.new("TextButton")
minimizar.Name = "Minimizar"
minimizar.BackgroundTransparency = 1
minimizar.Position = UDim2.new(1, -115, 0, 5)
minimizar.Size = UDim2.new(0, 35, 0, 35)
minimizar.Text = "—"
minimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizar.TextSize = 25
minimizar.Font = Enum.Font.GothamBold
minimizar.Parent = barra

local maximizar = Instance.new("TextButton")
maximizar.Name = "Maximizar"
maximizar.BackgroundTransparency = 1
maximizar.Position = UDim2.new(1, -78, 0, 5)
maximizar.Size = UDim2.new(0, 35, 0, 35)
maximizar.Text = "□"
maximizar.TextColor3 = Color3.fromRGB(255, 255, 255)
maximizar.TextSize = 22
maximizar.Font = Enum.Font.GothamBold
maximizar.Parent = barra

local cerrar = Instance.new("TextButton")
cerrar.Name = "Cerrar"
cerrar.BackgroundTransparency = 1
cerrar.Position = UDim2.new(1, -40, 0, 5)
cerrar.Size = UDim2.new(0, 35, 0, 35)
cerrar.Text = "X"
cerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
cerrar.TextSize = 20
cerrar.Font = Enum.Font.GothamBold
cerrar.Parent = barra

--==================================================
-- SEPARADOR
--==================================================

local separador = Instance.new("Frame")
separador.Name = "Separador"
separador.Size = UDim2.new(1, -20, 0, 1)
separador.Position = UDim2.new(0, 10, 0, 50)
separador.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
separador.BorderSizePixel = 0
separador.Parent = ventana

--==================================================
-- BOTÓN MACRO
--==================================================

local macro = Instance.new("TextButton")
macro.Name = "Macro"
macro.Size = UDim2.new(1, -40, 0, 65)
macro.Position = UDim2.new(0, 20, 0, 75)
macro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
macro.BorderSizePixel = 0
macro.Text = "MACRO : DESACTIVADA"
macro.TextColor3 = Color3.fromRGB(255, 255, 255)
macro.TextSize = 20
macro.Font = Enum.Font.GothamBold
macro.Parent = ventana

local macroCorner = Instance.new("UICorner")
macroCorner.CornerRadius = UDim.new(0, 8)
macroCorner.Parent = macro

--==================================================
-- BOTÓN FPS BOOST
--==================================================

local fps = Instance.new("TextButton")
fps.Name = "FPSBoost"
fps.Size = UDim2.new(1, -40, 0, 65)
fps.Position = UDim2.new(0, 20, 0, 155)
fps.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fps.BorderSizePixel = 0
fps.Text = "FPS BOOST : DESACTIVADO"
fps.TextColor3 = Color3.fromRGB(255, 255, 255)
fps.TextSize = 20
fps.Font = Enum.Font.GothamBold
fps.Parent = ventana

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 8)
fpsCorner.Parent = fps

--==================================================
-- BUSCAR SOLAMENTE LA PISTOLA
--==================================================

local function buscarPistola()

	local character = player.Character

	if not character then
		return nil
	end

	-- Pistola equipada
	local pistola = character:FindFirstChild(NOMBRE_PISTOLA)

	if pistola and pistola:IsA("Tool") then
		return pistola
	end

	-- Pistola en Backpack
	local backpack = player:FindFirstChildOfClass("Backpack")

	if backpack then

		pistola = backpack:FindFirstChild(NOMBRE_PISTOLA)

		if pistola and pistola:IsA("Tool") then
			return pistola
		end

	end

	return nil
end

--==================================================
-- MACRO
--==================================================

-- LocalScript
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local VELOCIDAD_SACAR = 0.01
local VELOCIDAD_GUARDAR = 0.01

local EN_USO = false

local function disparoRapido()
	if EN_USO then return end
	EN_USO = true

	local character = player.Character
	if not character then
		EN_USO = false
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		EN_USO = false
		return
	end

	-- Buscar el arma
	local arma = character:FindFirstChildOfClass("Tool")

	if not arma then
		local backpack = player:FindFirstChildOfClass("Backpack")
		if backpack then
			arma = backpack:FindFirstChildOfClass("Tool")
		end
	end

	if not arma then
		EN_USO = false
		return
	end

	-- SACAR
	humanoid:EquipTool(arma)
	task.wait(VELOCIDAD_SACAR)

	-- DISPARAR
	arma:Activate()

	-- GUARDAR
	task.wait(VELOCIDAD_GUARDAR)
	humanoid:UnequipTools()

	EN_USO = false
end

macro.MouseButton1Click:Connect(function()

	macroActiva = not macroActiva

	if macroActiva then

		macro.Text = "MACRO : ACTIVADA"
		macro.TextColor3 = Color3.fromRGB(0, 255, 100)

	else

		macro.Text = "MACRO : DESACTIVADA"
		macro.TextColor3 = Color3.fromRGB(255, 255, 255)

	end

end)

-- CLIC IZQUIERDO
UserInputService.InputBegan:Connect(function(input, procesado)
	if procesado then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		disparoRapido()
	end
end)

--==================================================
-- CLICK IZQUIERDO
--==================================================

UserInputService.InputBegan:Connect(function(input, procesado)

	if procesado then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		disparoRapido()
	end

end)

--==================================================
-- FPS BOOST
--==================================================

local function guardar(objeto, propiedad)

	if originales[objeto] == nil then
		originales[objeto] = {}
	end

	if originales[objeto][propiedad] == nil then
		originales[objeto][propiedad] = objeto[propiedad]
	end
end

local function activarFPSBoost()

	if fpsActivo then
		return
	end

	fpsActivo = true

	for _, objeto in ipairs(workspace:GetDescendants()) do

		if objeto:IsA("BasePart") then
			guardar(objeto, "Material")
			guardar(objeto, "CastShadow")

			objeto.Material = Enum.Material.SmoothPlastic
			objeto.CastShadow = false
		end

		if objeto:IsA("Texture") or objeto:IsA("Decal") then
			guardar(objeto, "Transparency")
			objeto.Transparency = 1
		end

		if objeto:IsA("ParticleEmitter") then
			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end

		if objeto:IsA("Smoke") then
			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end

		if objeto:IsA("Fire") then
			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end

		if objeto:IsA("Trail") then
			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end

		if objeto:IsA("Beam") then
			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end

		if objeto:IsA("PointLight")
			or objeto:IsA("SpotLight")
			or objeto:IsA("SurfaceLight") then

			guardar(objeto, "Enabled")
			objeto.Enabled = false
		end
	end

	for _, efecto in ipairs(Lighting:GetChildren()) do

		if efecto:IsA("BloomEffect")
			or efecto:IsA("BlurEffect")
			or efecto:IsA("ColorCorrectionEffect")
			or efecto:IsA("SunRaysEffect")
			or efecto:IsA("DepthOfFieldEffect") then

			guardar(efecto, "Enabled")
			efecto.Enabled = false
		end
	end

	fps.Text = "FPS BOOST : ACTIVADO"
	fps.TextColor3 = Color3.fromRGB(0, 255, 100)

	print("FPS BOOST ACTIVADO")
end

local function desactivarFPSBoost()

	if not fpsActivo then
		return
	end

	fpsActivo = false

	for objeto, propiedades in pairs(originales) do

		if objeto and objeto.Parent then

			for propiedad, valor in pairs(propiedades) do

				pcall(function()
					objeto[propiedad] = valor
				end)

			end
		end
	end

	table.clear(originales)

	fps.Text = "FPS BOOST : DESACTIVADO"
	fps.TextColor3 = Color3.fromRGB(255, 255, 255)

	print("FPS BOOST DESACTIVADO")
end

--==================================================
-- BOTÓN FPS
--==================================================

fps.MouseButton1Click:Connect(function()

	if fpsActivo then
		desactivarFPSBoost()
	else
		activarFPSBoost()
	end

end)

--==================================================
-- MINIMIZAR
--==================================================

local function mostrarContenido(mostrar)

	for _, objeto in ipairs(ventana:GetChildren()) do

		if objeto ~= barra and objeto:IsA("GuiObject") then
			objeto.Visible = mostrar
		end

	end

end

minimizar.MouseButton1Click:Connect(function()

	minimizado = not minimizado

	if minimizado then

		mostrarContenido(false)

		ventana.Size = UDim2.new(0, 430, 0, 50)

		minimizar.Text = "□"

	else

		ventana.Size = UDim2.new(0, 430, 0, 300)

		mostrarContenido(true)

		minimizar.Text = "—"

	end

end)

--==================================================
-- MAXIMIZAR / RESTAURAR
--==================================================

maximizar.MouseButton1Click:Connect(function()

	if minimizado then
		minimizado = false
		mostrarContenido(true)
		minimizar.Text = "—"
	end

	maximizado = not maximizado

	if maximizado then
		ventana.Size = UDim2.new(0, 600, 0, 400)
	else
		ventana.Size = UDim2.new(0, 430, 0, 300)
	end

end)

--==================================================
-- CERRAR
--==================================================

cerrar.MouseButton1Click:Connect(function()

	gui:Destroy()

end)

--==================================================
-- MOVER VENTANA
--==================================================

local arrastrando = false
local posicionInicial
local posicionVentana

barra.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		arrastrando = true
		posicionInicial = input.Position
		posicionVentana = ventana.Position

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not arrastrando then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - posicionInicial

		ventana.Position = UDim2.new(
			posicionVentana.X.Scale,
			posicionVentana.X.Offset + delta.X,
			posicionVentana.Y.Scale,
			posicionVentana.Y.Offset + delta.Y
		)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		arrastrando = false

	end

end)

--==================================================
-- ESTADO INICIAL DEL FPS
--==================================================

fps.Text = "FPS BOOST : DESACTIVADO"
fps.TextColor3 = Color3.fromRGB(255, 255, 255)

print("MOBILADOR HUB CARGADO")
