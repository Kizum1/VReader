local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage.APIs.GetBook
local HTTP = game:GetService("HttpService")
local Gutenberg = require(ReplicatedStorage.Gutenberg.Gutenberg)

API.OnServerInvoke = function(player, book_id)
	local url = string.format("https://www.gutenberg.org/cache/epub/%d/pg%d.txt", book_id, book_id)
	local text = HTTP:GetAsync(url)
	return text
end