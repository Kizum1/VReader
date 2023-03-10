local HTTP = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServiceScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local VRService = require(ReplicatedStorage.VR.VRService)
local API = ReplicatedStorage.APIs
local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")

local module = {
	CurrentBook = nil
}

function module:getBooks()
	local RawJSON = HTTP:JSONDecode(API.GetBooks:InvokeServer()).results
	local Books = {}
	for index, BookRaw in ipairs(RawJSON) do
		local Book = module.BookfromQuery(BookRaw)
		table.insert(Books, Book)
	end
	return Books
end

function module:getBook(book_id)
	local text = API.GetBook:InvokeServer(book_id)
	local Book = formatBookText(text)
	return Book
end

function module:search(query)
	
	local Results =  HTTP:JSONDecode(API.SearchBooks:InvokeServer(query)).results
	local Books = {}
	local limit = query.limit or 0
	
	for i, BookRaw in ipairs(Results) do
		table.insert(Books, module.BookfromQuery(BookRaw))
		if i > 0 and i == limit then
			break
		end	
	end
	
	return Books
end


function module.BookfromQuery(query)
	local INCREM = 29
	local BookItem	
	BookItem = {
		Author = query.authors[1],
		Title = query.title,
		Id = query.id,
		getPhysicalBook = function()
			local BookInfo = {
				Author = query.authors[1],
				Title = query.title,
				Id = query.id,
			}
			if module.CurrentBook ~= nil then
				API.Records.StoreBook:InvokeServer(BookInfo, module.CurrentBook.Curr_Line)
				module.CurrentBook.Book:Destroy()
				module.CurrentBook = nil
			end
			
			local Book = script.Parent.Book:Clone()
			Book.Parent = game.Workspace
			module.CurrentBook = BookItem
			module.CurrentBook.Book = Book
			

			module.CurrentBook.Book.Cover.SurfaceGui.TextLabel.Text = module.CurrentBook.Title .. "\n" .. "by\n"	 .. module.CurrentBook.Author.name
			module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel.TextTransparency = 1
			module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel.TextTransparency = 1
			module.CurrentBook.Book.LeftPage.SurfaceGui.Left.BackgroundTransparency = 1
			module.CurrentBook.Book.RightPage.SurfaceGui.Right.BackgroundTransparency = 1
			module.CurrentBook.Book.Spine.Transparency = 1
			
			local Text = module:getBook(query.id)

			module.CurrentBook.Curr_Line = API.Records.GetBook:InvokeServer(BookInfo) or 1
			module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel.Text = GeneratePage(Text, module.CurrentBook.Curr_Line, INCREM)
			module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel.Text = GeneratePage(Text, module.CurrentBook.Curr_Line + INCREM, INCREM)
			module.CurrentBook.Book.Flipper.Open:Play()	
			
			local UISConnection 
			UISConnection = UIS.InputBegan:Connect(function(input, processed)
				
				if  module.CurrentBook == nil or module.CurrentBook.Book == nil or not (input.KeyCode == Enum.KeyCode.ButtonY or input.KeyCode == Enum.KeyCode.ButtonX or  input.KeyCode == Enum.KeyCode.ButtonB) then return end
				
				if input.KeyCode == Enum.KeyCode.ButtonY or  input.KeyCode == Enum.KeyCode.ButtonB then
					module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel.TextTransparency = 1
					module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel.TextTransparency = 1		
					TweenService:Create(module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel, TweenInfo.new(1,4), {
						TextTransparency = 1
					}):Play()
					TweenService:Create(module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel, TweenInfo.new(1,4), {
						TextTransparency = 1
					}):Play()				
					module.CurrentBook.Book.Flipper.Turn:Play()					
					if module.CurrentBook.Curr_Line- 2 * INCREM >= 0  and input.KeyCode == Enum.KeyCode.ButtonY then
						module.CurrentBook.Curr_Line = module.CurrentBook.Curr_Line - 2 * INCREM
						FlipBook(module.CurrentBook.Book.Flipper, 1)	
						end
					if module.CurrentBook.Curr_Line - 2 * INCREM <= #Text and input.KeyCode == Enum.KeyCode.ButtonB then
						module.CurrentBook.Curr_Line = module.CurrentBook.Curr_Line + 2 * INCREM
						FlipBook(module.CurrentBook.Book.Flipper, 0)	
						end						
					module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel.Text = GeneratePage(Text, module.CurrentBook.Curr_Line, INCREM)
					module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel.Text = GeneratePage(Text, module.CurrentBook.Curr_Line + INCREM, INCREM)				
					--API.Records.StoreBook:InvokeServer(BookInfo, CurrentBook.Curr_Line)
					TweenService:Create(module.CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel, TweenInfo.new(2,4), {
						TextTransparency = 0
					}):Play()
					TweenService:Create(module.CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel, TweenInfo.new(2,4), {
						TextTransparency = 0
					}):Play()
				elseif input.KeyCode == Enum.KeyCode.ButtonX then
					if module.CurrentBook == nil or module.CurrentBook.Book == nil then return end
					module.CurrentBook.Book.Flipper.Close:Play()	
					DestroyBook(module.CurrentBook)
					UISConnection:Disconnect()
				end
			end)
			
			RunService:BindToRenderStep("VrHandler", 1, function()
				if module.CurrentBook == nil or module.CurrentBook.Book == nil then
					RunService:UnbindFromRenderStep("VrHandler")
					return 
				end
				module.CurrentBook.Book:SetPrimaryPartCFrame(VRService.Rig.CFrames.Hand.Right():ToWorldSpace(CFrame.new(0, 0.2, 0)))
			end)
			
			GenerateBook(module.CurrentBook)
			
			local DestroyFunction 
			
			DestroyFunction = LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
				RunService:UnbindFromRenderStep("VrHandler")
				API.Records.StoreBook:InvokeServer(BookInfo, module.CurrentBook.Curr_Line)
				module.CurrentBook.Book:Destroy()
				module.CurrentBook = nil
				DestroyFunction:Disconnect()
			end)
			
		end,
	} 
	
	return BookItem
end



function FlipBook(Flipper, direction)
	local BookSpine = Flipper.Parent.Spine
	local iteration = 20
	
	for i = 0, iteration do
		wait()
		local deg = math.abs(180 * direction - (180/iteration * i))
		local k = Flipper.Size.Z / 2
		local z_offset = k * math.cos(math.rad(deg))
		local y_offset = k * math.sin(math.rad(deg)) 
		Flipper.CFrame = BookSpine.CFrame:ToWorldSpace(CFrame.new(0, y_offset + BookSpine.Size.Y / 2 - 0.02,  - z_offset)) * CFrame.Angles(math.rad(deg), math.rad(0), math.rad(0))
	end

end

function GeneratePage(text, start, num_lines)
	local page = ""
	for i = 1, num_lines do
		page = page .. text[start + i - 1] .. "\n"
	end
	return page
end

function GenerateBook(CurrentBook)
	local length = 3
	TweenService:Create(CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel, TweenInfo.new(length,4), {
		TextTransparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel, TweenInfo.new(length,4), {
		TextTransparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.LeftPage.SurfaceGui.Left, TweenInfo.new(length,4), {
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage.SurfaceGui.Right, TweenInfo.new(length,4), {
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.LeftPage, TweenInfo.new(length,4), {
		Transparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage, TweenInfo.new(length,4), {
		Transparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.Flipper, TweenInfo.new(length,4), {
		Transparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.Hand, TweenInfo.new(length,4), {
		Transparency = 0
	}):Play()
	TweenService:Create(CurrentBook.Book.Cover, TweenInfo.new(length,4), {
		Transparency = 0
	}):Play()	
	for i, Object in CurrentBook.Book:GetChildren() do
		if Object.Name == "Backing" then
			TweenService:Create(Object, TweenInfo.new(length,4), {
				Transparency = 0
			}):Play()
		end
	end
	coroutine.wrap(function()
		CurrentBook.Book.Hand.Particles.Enabled = true
		CurrentBook.Book.LeftPage.SurfaceGui.AlwaysOnTop = false
		CurrentBook.Book.RightPage.SurfaceGui.AlwaysOnTop = false
		TweenService:Create(CurrentBook.Book.Hand.Glow, TweenInfo.new(length/2,4), {
			Range = 8
		}):Play()
		wait(length/2)
		CurrentBook.Book.Hand.Particles.Enabled = false
		TweenService:Create(CurrentBook.Book.Hand.Glow, TweenInfo.new(length/2,4), {
			Range = 0
		}):Play()
		wait(length/2)
		CurrentBook.Book.LeftPage.SurfaceGui.AlwaysOnTop = true
		CurrentBook.Book.RightPage.SurfaceGui.AlwaysOnTop = true
	end)()
end

function DestroyBook(CurrentBook)
	local length = 1
	TweenService:Create(CurrentBook.Book.LeftPage.SurfaceGui.Left.TextLabel, TweenInfo.new(length,4), {
		TextTransparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage.SurfaceGui.Right.TextLabel, TweenInfo.new(length,4), {
		TextTransparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.LeftPage.SurfaceGui.Left, TweenInfo.new(length,4), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage.SurfaceGui.Right, TweenInfo.new(length,4), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.LeftPage, TweenInfo.new(length,4), {
		Transparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.RightPage, TweenInfo.new(length,4), {
		Transparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.Flipper, TweenInfo.new(length,4), {
		Transparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.Hand, TweenInfo.new(length,4), {
		Transparency = 1
	}):Play()
	TweenService:Create(CurrentBook.Book.Cover, TweenInfo.new(length,4), {
		Transparency = 1
	}):Play()
	for i, Object in CurrentBook.Book:GetChildren() do
		if Object.Name == "Backing" then
			TweenService:Create(Object, TweenInfo.new(length,4), {
				Transparency = 1
			}):Play()
		end
	end
	local BookInfo = {
		Author = module.CurrentBook.Author,
		Title = module.CurrentBook.Title,
		Id = module.CurrentBook.Id,
	}
	print(module.CurrentBook.Curr_Line)
	API.Records.StoreBook:InvokeServer(BookInfo, module.CurrentBook.Curr_Line)
	coroutine.wrap(function()
		if  CurrentBook == nil or CurrentBook.Book == nil then return end
		CurrentBook.Book.Hand.Particles.Enabled = true
		CurrentBook.Book.LeftPage.SurfaceGui.AlwaysOnTop = false
		CurrentBook.Book.RightPage.SurfaceGui.AlwaysOnTop = false
		TweenService:Create(CurrentBook.Book.Hand.Glow, TweenInfo.new(length/2,4), {
			Range = 8
		}):Play()
		wait(length/2)
		CurrentBook.Book.Hand.Particles.Enabled = false
		TweenService:Create(CurrentBook.Book.Hand.Glow, TweenInfo.new(length/2,4), {
			Range = 0
		}):Play()
	end)()
	wait(length)
	if (CurrentBook.Book) then
		CurrentBook.Book:Destroy()
		CurrentBook.Book = nil
	end
	module.CurrentBook = nil
end

function formatBookText(text)
	local _, book_start = string.find(text, "*** START OF THE PROJECT GUTENBERG EBOOK A ROOM WITH A VIEW ***")
	local book_end, _ = string.find(text, "*** END OF THE PROJECT GUTENBERG EBOOK A ROOM WITH A VIEW ***")
	book_start = book_start and book_start or 0
	local Text = book_end and string.sub(text, book_start + 1, book_end) or string.sub(text, book_start)
	return Text:split("\n")

end
return module