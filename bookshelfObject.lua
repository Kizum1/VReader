

function fillshelf(booknames, bookcase)
	local bookcase = bookcase.Model
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
	for index,titles in ipairs(booknames) do
		if i > tshelf_cap then
			tnotfull = false
		end
		if k > bshelf_cap then
			bnotfull = false
		end
		if j > mshelf_cap then
			mnotfull = false
		end
		if tnotfull then
			local newBook = book:Clone()
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)
			newBook.Part.CFrame = (tshelf.CFrame * CFrame.new(i,-1,0))
			newBook.Union.CFrame = (tshelf.CFrame * CFrame.new(i,-1,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = titles
			newBook.Parent = script.Parent
			table.insert(objects, newBook)
			i = i+0.35
			continue
			
		elseif mnotfull then
			local newBook = book:Clone()
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)
			newBook.Part.CFrame = (mshelf.CFrame * CFrame.new(j,-1,0))
			newBook.Union.CFrame = (mshelf.CFrame * CFrame.new(j,-1,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = titles
			newBook.Parent = script.Parent
			table.insert(objects, newBook)
			j = j+0.35
			continue
			
		elseif bnotfull then
			local newBook = book:Clone()
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)
			newBook.Part.CFrame = (bshelf.CFrame * CFrame.new(k,-1.8,0))
			newBook.Union.CFrame = (bshelf.CFrame * CFrame.new(k,-1.8,0)) * CFrame.Angles(0, math.rad(180), 0)
			newBook.Union.Color = Color3.fromRGB(r,g,b)
			newBook.Union.SurfaceGui.Frame.TextLabel.Text = titles
			newBook.Parent = script.Parent
			table.insert(objects, newBook)
			k = k+0.35
			continue
			
		end

	end

end



function onMouseClick()
	print('Poop')
end

