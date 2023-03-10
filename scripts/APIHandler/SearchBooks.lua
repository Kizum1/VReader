local HTTP = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gutenberg = require(ReplicatedStorage.Gutenberg.Gutenberg)
local API = ReplicatedStorage.APIs.SearchBooks

function search(player, query)
	local search = query.search:gsub(" ", "%%20")
	local url = ""
	local limit = query.limit or 0
	if query.by == "topic" then
		url = "http://gutendex.com/books" .. "?topic=" .. search
	elseif query.by == "general" or query.by == nil then
		url = "http://gutendex.com/books" .. "?search=" .. search
	end
	local response = HTTP:GetAsync(url)
	return response
	
end
API.OnServerInvoke = search