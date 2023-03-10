local HTTP = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage.APIs.GetBooks

function GetBooks(player)
	local url = "http://gutendex.com/books"
	local response = HTTP:GetAsync(url)
	local RawJSON =  response
	return RawJSON
end
API.OnServerInvoke = GetBooks