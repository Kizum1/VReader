local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Gutenberg = require(ReplicatedStorage.Gutenberg.Gutenberg)
local SurfaceGui = ReplicatedStorage.Gutenberg.Bookcase.SurfaceGui:Clone()
local BookButton = ReplicatedStorage.Gutenberg.Bookcase.Book
local Bookcase = game.Workspace.Computer.Monitor.Screen
local Textbox = SurfaceGui.Window.BottomBar.TextBox
local ScrollingFrame = SurfaceGui.Window.Viewport.ScrollingFrame
local Books = Gutenberg:getBooks()
for i, Book in ipairs(Books) do
	local NewButton = BookButton:Clone()
	NewButton.Parent = ScrollingFrame
	NewButton.Name = "Book" .. i
	NewButton.Text = Book.Title
	NewButton.MouseButton1Click:Connect(function()
		Book.getPhysicalBook()
	end)
end
SurfaceGui.Parent= Bookcase

Textbox.FocusLost:Connect(function(enter, inputObject)
	for i, child in ipairs(ScrollingFrame:GetChildren()) do
		if child.ClassName == "TextButton" then
			child:Destroy()
		end
	end
	local Books = Gutenberg:search({
		search = Textbox.Text
	})
	for i, Book in ipairs(Books) do
		local NewButton = ReplicatedStorage.Gutenberg.Bookcase.Book:Clone()
		NewButton.Parent = ScrollingFrame
		NewButton.Name = "Book" .. i
		NewButton.Text = Book.Title
		NewButton.MouseButton1Click:Connect(function()
			Book.getPhysicalBook()
		end)
	end
end)




local LazerMode = 0
game.StarterGui:SetCore("VRLaserPointerMode", LazerMode)
--game.StarterGui:SetCore("VRHub", LazerMode)
