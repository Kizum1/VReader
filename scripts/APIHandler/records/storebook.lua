local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage.APIs.Records.StoreBook
local DataStoreService = game:GetService("DataStoreService")
local Records = DataStoreService:GetDataStore("PlayerLibrary")



API.OnServerInvoke = function(Player : Player, BookInfo, CurrentPage)
	BookInfo.CurrentPage = CurrentPage
	Records:SetAsync(Player.UserId .. "/" .. BookInfo.Id, BookInfo)
end