local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage.APIs.Records.GetBook
local DataStoreService = game:GetService("DataStoreService")
local Records = DataStoreService:GetDataStore("PlayerLibrary")



API.OnServerInvoke = function(Player : Player, BookInfo)
	
	local Book = Records:GetAsync(Player.UserId .. "/" .. BookInfo.Id)
	if Book == nil or Book.CurrentPage == nil then
		StoreBook(Player, BookInfo, 1)
		return 1
	end
	return Book.CurrentPage
end

function StoreBook(Player : Player, BookInfo, CurrentPage)
	BookInfo.CurrentPage = CurrentPage
	Records:SetAsync(Player.UserId .. "/" .. BookInfo.Id, BookInfo)
end