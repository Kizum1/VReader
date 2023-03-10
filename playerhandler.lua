local Players = game:GetService("Players")
function onPlayerAdded(Player)
	Player.CharacterAdded:Connect(function(Character)
		script.Aight.Parent = Character.PrimaryPart
		script.RF.Parent = Character.PrimaryPart		
	end)
end
Players.PlayerAdded:Connect(onPlayerAdded)


