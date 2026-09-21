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
           -- Garanta que essas variáveis de controle estejam no topo do seu painel
local players = game:GetService("Players")
local player = players.LocalPlayer
local flingActive = false

-- =============================================================================
-- COLOQUE O CÓDIGO ABAIXO EXATAMENTE DENTRO DO CALLBACK DO SEU BOTÃO DE FLING
-- =============================================================================
local target = nil
if AlvoSelecionado ~= "" then
    for _, p in pairs(players:GetPlayers()) do
        if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
           (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
            target = p
            break
        end
    end
end

if target and target ~= player then
    Rayfield:Notify({Title = "Ataque Iniciado", Content = "Executando fling em: " .. target.Name, Duration = 3, Image = "swords"})
    
    flingActive = false
    task.wait(0.05)
    flingActive = true

    task.spawn(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local originalCFrame = root and root.CFrame
        local backpack = player:WaitForChild("Backpack")
        local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

        if not backpack:FindFirstChild("SoccerBall") then
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
        end
        repeat task.wait() until backpack:FindFirstChild("SoccerBall")
        backpack.SoccerBall.Parent = char
        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. player.Name)
        char.SoccerBall.Parent = backpack
        local Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name)

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
            
            while flingActive and thum.Health > 0 and tchar:IsDescendantOf(workspace) and target.Parent == players do
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
                
           Rayfield:Notify({
               Title = "Moderação Leve",
               Content = "Comando Fling enviado para: " .. AlvoSelecionado,
               Duration = 4
           })
       end
   end,
})

MainTab:CreateButton({
   Name = ";uncover",
   Callback = function()
      -- =============================================================================
      -- BOTÃO ATUALIZADO: ;uncover (LIMPAR SKIN + DESTRUIR ÁUDIOS DO ALVO)
      -- =============================================================================
      local target = nil
      if AlvoSelecionado ~= "" then
          -- Correção: Usando 'Players' com P maiúsculo conforme seu script principal
          for _, p in pairs(game:GetService("Players"):GetPlayers()) do
              if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
                 (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
                  target = p
                  break
              end
          end
      end

      if target and target.Character then
          Rayfield:Notify({
              Title = "Moderação", 
              Content = "Limpando skin e silenciando: " .. target.Name, 
              Duration = 3, 
              Image = 4483362458
          })
          
          task.spawn(function()
              local tchar = target.Character
              -- 1. Limpeza física de roupas e acessórios bypassados
              for _, obj in pairs(tchar:GetChildren()) do
                  if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("GraphicShirt") or obj:IsA("ShirtGraphic") or obj:IsA("Accessory") or obj:IsA("CharacterMesh") then
                      obj:Destroy()
                  end
              end
              
              -- 2. Varredura e destruição de sons inapropriados na vizinhança do alvo
              for _, obj in pairs(tchar:GetDescendants()) do
                  if obj:IsA("Sound") then
                      obj:Stop()
                      obj:Destroy()
                  end
              end
              
              -- Limpa também o rádio ou ferramentas de som guardadas na mochila dele
              if target:FindFirstChild("Backpack") then
                  for _, tool in pairs(target.Backpack:GetDescendants()) do
                      if tool:IsA("Sound") then
                          tool:Stop()
                          tool:Destroy()
                      end
                  end
              end
          end)
      else
          Rayfield:Notify({
              Title = "Erro", 
              Content = "Jogador não encontrado.", 
              Duration = 3, 
              Image = 4483362458
          })
      end
   end,
})

MainTab:CreateButton({
   Name = ";view",
   Callback = function()
      local target = nil
      if AlvoSelecionado ~= "" then
          -- Correção: Usando 'Players' com P maiúsculo
          for _, p in pairs(game:GetService("Players"):GetPlayers()) do
              if string.lower(p.Name):match("^" .. string.lower(AlvoSelecionado)) or 
                 (p.DisplayName and string.lower(p.DisplayName):match("^" .. string.lower(AlvoSelecionado))) then
                  target = p
                  break
              end
          end
      end

      if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
          Rayfield:Notify({
              Title = "Espionagem", 
              Content = "Assistindo: " .. target.Name, 
              Duration = 3, 
              Image = 4483362458
          })
          workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
      else
          Rayfield:Notify({
              Title = "Erro", 
              Content = "Jogador não encontrado ou sem personagem.", 
              Duration = 3, 
              Image = 4483362458
          })
      end
   end,
})

MainTab:CreateButton({
   Name = ";unview",
   Callback = function()
      -- Correção: Usando 'LocalPlayer' com a grafia exata do topo do seu Hub
      local char = game:GetService("Players").LocalPlayer.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")

      if hum then
          Rayfield:Notify({
              Title = "Espionagem", 
              Content = "Câmera restaurada.", 
              Duration = 3, 
              Image = 4483362458
          })
          workspace.CurrentCamera.CameraSubject = hum
      else
          Rayfield:Notify({
              Title = "Erro", 
              Content = "Não foi possível restaurar sua câmera.", 
              Duration = 3, 
              Image = 4483362458
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

-- =============================================================================
-- PARTE 1 DE 3: ESCUTA DO CHAT ANTIGO E BUSCA DO ALVO
-- =============================================================================
player.Chatted:Connect(function(msg)
    local comando, argumento = msg:match("^(;fling)%s+(.+)$")
    if comando and argumento then
        local target = nil
        for _, p in pairs(players:GetPlayers()) do
            local nameLower = string.lower(p.Name)
            local displayLower = p.DisplayName and string.lower(p.DisplayName) or ""
            local argLower = string.lower(argumento)
            
            if nameLower:find(argLower) or displayLower:find(argLower) then
                target = p
                break
            end
        end

        if target and target ~= player then
            Rayfield:Notify({Title = "Chat Comando", Content = "Executando fling em: " .. target.Name, Duration = 3, Image = "swords"})
            
            flingActive = false
            task.wait(0.05)
            flingActive = true

            task.spawn(function()
                        -- =============================================================================
-- PARTE 2 DE 3: CAPTURA DA BOLA DO BROOKHAVEN E CONFIGURAÇÃO DA FÍSICA
-- =============================================================================
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local originalCFrame = root and root.CFrame
                local backpack = player:WaitForChild("Backpack")
                local ServerBalls = workspace:FindFirstChild("WorkspaceCom") and workspace.WorkspaceCom:FindFirstChild("001_SoccerBalls") or workspace:FindFirstChild("001_SoccerBalls")

                if not backpack:FindFirstChild("SoccerBall") then
                    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
                end
                repeat task.wait() until backpack:FindFirstChild("SoccerBall")
                
                backpack.SoccerBall.Parent = char
                task.wait(0.1)
                char.SoccerBall.Parent = backpack
                
                local Ball = ServerBalls and ServerBalls:FindFirstChild("Soccer" .. player.Name)
                if not Ball then
                    flingActive = false
                    return
                end

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
                            -- =============================================================================
-- PARTE 3 DE 3: LOOP DE ATAQUE, LIMPEZA DE FÍSICA E REDIRECIONAMENTO DE CHAT
-- =============================================================================
                    while flingActive and thum.Health > 0 and tchar:IsDescendantOf(workspace) and target.Parent == players do
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
end)

-- Ponte de compatibilidade para servidores com TextChatService ativo
local TextChatService = game:GetService("TextChatService")
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(textMessage)
        if textMessage.TextSource and textMessage.TextSource.UserId == player.UserId then
            if textMessage.Text:match("^(;fling)") then
                player.Chatted:Fire(textMessage.Text)
            end
        end
    end)
end

-- =============================================================================
-- SISTEMA DE ESCUTA DE CHAT UNIFICADO RESTRITO (SISTEMA LEGADO)
-- =============================================================================
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)

    -- 1. PROCESSO DO COMANDO: ;uncover VIA CHAT
    local cmdUnc, argUnc = msg:match("^(;uncover)%s+(.+)$")
    if cmdUnc and argUnc then
        local target = nil
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            local nameLower = string.lower(p.Name)
            local displayLower = p.DisplayName and string.lower(p.DisplayName) or ""
            local argLower = string.lower(argUnc)
            
            if nameLower:find(argLower) or displayLower:find(argLower) then
                target = p
                break
            end
        end

        if target and target.Character then
            Rayfield:Notify({
                Title = "Moderação Chat", 
                Content = "Limpando skin e áudio de: " .. target.Name, 
                Duration = 3, 
                Image = 4483362458
            })
            
            task.spawn(function()
                local tchar = target.Character
                for _, obj in pairs(tchar:GetChildren()) do
                    if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("GraphicShirt") or obj:IsA("ShirtGraphic") or obj:IsA("Accessory") or obj:IsA("CharacterMesh") then
                        obj:Destroy()
                    end
                end
                for _, obj in pairs(tchar:GetDescendants()) do
                    if obj:IsA("Sound") then obj:Stop() obj:Destroy() end
                end
                if target:FindFirstChild("Backpack") then
                    for _, tool in pairs(target.Backpack:GetDescendants()) do
                        if tool:IsA("Sound") then tool:Stop() tool:Destroy() end
                    end
                end
            end)
        end
    end

    -- 2. PROCESSO DO COMANDO: ;view VIA CHAT
    local cmdView, argView = msg:match("^(;view)%s+(.+)$")
    if cmdView and argView then
        local target = nil
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            local nameLower = string.lower(p.Name)
            local displayLower = p.DisplayName and string.lower(p.DisplayName) or ""
            local argLower = string.lower(argView)
            
            if nameLower:find(argLower) or displayLower:find(argLower) then
                target = p
                break
            end
        end

        if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
            Rayfield:Notify({
                Title = "Espionagem", 
                Content = "Assistindo: " .. target.Name, 
                Duration = 3, 
                Image = 4483362458
            })
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
        end
    end

    -- 3. PROCESSO DO COMANDO: ;unview VIA CHAT
    if msg:lower() == ";unview" or msg:lower() == ";unspy" then
        local char = game:GetService("Players").LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            Rayfield:Notify({
                Title = "Espionagem", 
                Content = "Câmera restaurada.", 
                Duration = 3, 
                Image = 4483362458
            })
            workspace.CurrentCamera.CameraSubject = hum
        end
    end
end)

-- =============================================================================
-- PONTE DE COMPATIBILIDADE PARA O NOVO CHAT (TextChatService - Padrão do Brookhaven)
-- =============================================================================
local TextChatService = game:GetService("TextChatService")
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.MessageReceived:Connect(function(textMessage)
        if textMessage.TextSource and textMessage.TextSource.UserId == game:GetService("Players").LocalPlayer.UserId then
            local txt = textMessage.Text
            if txt:match("^(;uncover)") or txt:match("^(;view)") or txt:lower() == ";unview" or txt:lower() == ";unspy" then
                game:GetService("Players").LocalPlayer.Chatted:Fire(textMessage.Text)
            end
        end
    end)
end

