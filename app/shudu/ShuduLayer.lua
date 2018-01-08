local size = cc.Director:getInstance():getWinSize()
local ShuduLayer = class("ShuduLayer",function()
    local layer = cc.Layer:create();
    return layer
end)

function ShuduLayer:ctor()
    self:addBaseUI()
    self:addMainUI()
end

function ShuduLayer:addBaseUI()
    local exitBtnEvent = function(target,state)
        if state == ccui.TouchEventType.ended then
            local scene = CreateWelcomeScene()
            local trans = cc.TransitionFade:create(1,scene)
            cc.Director:getInstance():replaceScene(trans)
        end
    end

    local exitBtn = ccui.Button:create("star/exit.png")
    exitBtn:setPosition(size.width-exitBtn:getContentSize().width/2,size.height-exitBtn:getContentSize().height/2)
    exitBtn:addTouchEventListener(exitBtnEvent)
    self:addChild(exitBtn,1)
end

function ShuduLayer:addMainUI()
    local bg = cc.Sprite:create("shudu/grid_9_9.png")
    bg:setPosition(size.width/2,size.height/2)
    self:addChild(bg)
    
    local gap = 65
    local yy  = 33
    local xx  = -10
    for i = 1,9 do
        for j = 1,9 do
            local sp = cc.Sprite:create("shudu/fill_number_8.png");
            sp:setPosition(i*gap-xx,j*gap)
            bg:addChild(sp)
        end
    end
end

return ShuduLayer