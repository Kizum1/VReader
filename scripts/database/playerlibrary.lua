local DataStoreService = game:GetService("DataStoreService")
local module = {
	Records = DataStoreService:GetDataStore("PlayerLibrary")
}

function module:StoreBook(Player : Player, Book, CurrentPage)
	Book.CurrentPage = CurrentPage
	local Book = module.Records:GetAsync(Player .. "/" .. Book.id)
	if Book == nil then
		module.Records:SetAsync(Player .. "/" .. Book.id, Book)
	end
end
function module:GetBook(Player : Player, Book)
	local Book = module.Records:GetAsync(Player .. "/" .. Book.id)
	if Book == nil then
		self:StoreBook(Player, Book, 1)
		return 1
	end
	return Book
end
return module
