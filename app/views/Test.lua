local s = cc.Director:getInstance():getWinSize()
local GameMainLayer = nil
GameMainLayer = function()
    local ret = cc.Layer:create()
    local pBg = cc.Sprite:create("resoures/card/zhan_jiang_yuji.png")
    pBg:setPosition(cc.p(s.width/2,s.height/2))
    ret:addChild(pBg,1)
    return ret
end

--//全局方法创建场景
function cc.exports.CreateGameScene()
    print("CreateGameScene...")
    local scene = cc.Scene:create()
    local layer = GameMainLayer()
    scene:addChild(layer)
    return scene
end

















