
cc.FileUtils:getInstance():setPopupNotify(false)    --ȡ������luac�ļ�
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "app.views.Test"    --����Test.lua
require("app.views.Test02")
require "app.star.Welcome"
require "app.three.ChunkMain"
require "app.star.Star"
require "app.star.GameScene"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
