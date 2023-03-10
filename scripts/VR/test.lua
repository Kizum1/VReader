local Gutenberg = require(game:GetService("ServerScriptService").APIs.Gutenberg)

print(Gutenberg:search({search="horror", by="topic", limit=5}))