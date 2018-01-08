local s = cc.Director:getInstance():getWinSize()
local GameMainLayer = {}
function GameMainLayer:createLayer()
    local ret = cc.Layer:create()
    local pBg = cc.Sprite:create("resoures/card/zhan_jiang_yuji.png")
    pBg:setPosition(cc.p(s.width/2,s.height/2))
    ret:addChild(pBg,1)
    

    
    local spObj = import("src.app.views.Test03")
    local sp = spObj.new(243,156,111,ret)
--    ret:addChild(sp,2);


    return ret
end

--//全局方法创建场景
function cc.exports.CreateTestScene()
    print("CreateTestScene...")
    local scene = cc.Scene:create()
    local layer = GameMainLayer:createLayer()
    scene:addChild(layer)
    return scene
end






