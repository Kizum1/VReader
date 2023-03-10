local Gutenberg = require(game:GetService("ReplicatedStorage").Gutenberg.Gutenberg)

local module = {}


function module.fillshelf(booknames, bookcase)
	bookcase = bookcase.Model
	local tshelf = bookcase.tshelf
	local bshelf = bookcase.bshelf
	local mshelf = bookcase.mshelf
	local redge = bookcase.redge
	local ledge = bookcase.ledge
	local shelf_size = bookcase.tshelf.Size
	local book = game.Workspace.Book
	local objects = {}

	local tshelf_cap, mshelf_cap, bshelf_cap = shelf_size.Z, shelf_size.Z, shelf_size.Z
	local tnotfull = true
	local mnotfull = true
	local bnotfull = true
	local i = -tshelf_cap
	local j = -mshelf_cap
	local k = -bshelf_cap
	for index, Book in ipairs(booknames) do

		local newBook = book:Clone()
		if i > tshelf_cap then
			tnotfull = false
		end
		if k > bshelf_cap then
			bnotfull = false
		end
		if j > mshelf_cap then
			mnotfull = false
		end
		local r = math.random(1,255)
		local g = math.random(1,255)
		local b = math.random(1,255)
		local clickDetector = newBook.ClickDetector


		local ubase = newBook.Union.CFrame
		local pbase = newBook.Part.CFrame
		
		if tnotfull then
			
			newBook.Part.CFrame = (tshelf.CFrame * CFrame.new(i,-1,0))
			newBook.Union.CFrame = (tshelf.CFrame * CFrame.new(i,-1,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = Book.Title
			newBook.Parent = script.Parent

			clickDetector.MouseClick:Connect(clickedBook(newBook, Book))
			table.insert(objects, newBook)
			i = i+0.35
			continue

		elseif mnotfull then
			
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)
			newBook.Part.CFrame = (mshelf.CFrame * CFrame.new(j,-1,0))
			newBook.Union.CFrame = (mshelf.CFrame * CFrame.new(j,-1,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = Book.Title
			newBook.Parent = script.Parent

			local clickDetector = newBook.ClickDetector


			local ubase = newBook.Union.CFrame
			local pbase = newBook.Part.CFrame
			clickDetector.MouseClick:Connect(clickedBook(newBook, Book))
			table.insert(objects, newBook)
			j = j+0.35
			
			continue

		elseif bnotfull then

		
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)
			newBook.Part.CFrame = (bshelf.CFrame * CFrame.new(k,-1.8,0))
			newBook.Union.CFrame = (bshelf.CFrame * CFrame.new(k,-1.8,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = Book.Title
			newBook.Parent = script.Parent

			local clickDetector = newBook.ClickDetector


			local ubase = newBook.Union.CFrame
			local pbase = newBook.Part.CFrame

			clickDetector.MouseClick:Connect(clickedBook(newBook, Book))
			table.insert(objects, newBook)
			k = k+0.35
			continue

		end

	end

end


function clickedBook(newBook, Book)
	local ubase = newBook.Union.CFrame
	local pbase = newBook.Part.CFrame
	return function()
		local unow = newBook.Union.CFrame
		if ubase == unow then
			newBook.Union.CFrame = newBook.Union.CFrame * CFrame.new(0,0,1)
			newBook.Part.CFrame = newBook.Part.CFrame * CFrame.new(0,0,-1)
			Book.getPhysicalBook()
		else
			newBook.Union.CFrame = ubase
			newBook.Part.CFrame = pbase	
		end
	end
end





return module
