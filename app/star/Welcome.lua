
local size = cc.Director:getInstance():getWinSize()
local WelComeLayer = {}

WelComeLayer.createLayer = function()
    local self = WelComeLayer
    local layer = cc.Layer:create()
    self.addBaseUi(layer)
    self.layoutUi(layer)
    return layer
end

--创建初始化场景
function cc.exports.CreateWelcomeScene()
    local scene = cc.Scene:create()
    local layer = WelComeLayer:createLayer()
    scene:addChild(layer)
    return scene
end

WelComeLayer.addBaseUi = function(layer)
    local mainbacktop = cc.Sprite:create("star/mainbacktop.png")
    mainbacktop:setPosition(cc.p(size.width/2,size.height-mainbacktop:getContentSize().height/2))
    layer:addChild(mainbacktop,1)
    
    local mainbackbottom = cc.Sprite:create("star/mainbackbottom.png")
    mainbackbottom:setPosition(size.width/2,mainbackbottom:getContentSize().height/2)
    layer:addChild(mainbackbottom)
end

WelComeLayer.layoutUi = function(layer)
--   layoutbutton
    local basePos = cc.p(size.width/2,size.height/2+size.height*0.1)
    local gap = 10
    
    local function newgameBtnEvent(target,state)
        if state == ccui.TouchEventType.ended then
            local scene = CreateGameScene()
            local act   = cc.TransitionFade:create(0.5,scene)
            cc.Director:getInstance():replaceScene(act)
        end
    end
    
    local function resumeBtnEvent(target,state)
        if state == ccui.TouchEventType.ended then
            local scene = ChunkMainCreateScene()
            local act = cc.TransitionZoomFlipX:create(0.5,scene)
            cc.Director:getInstance():replaceScene(act)
        end
    end
    
    local function helpBtnEvent(target,state)
        if state == ccui.TouchEventType.ended then
            local Dragon = import("src.app.hundragon.Dragon")
            local scene = Dragon:new()
            local act = cc.TransitionFadeUp:create(0.5,scene)
            cc.Director:getInstance():replaceScene(act)
        end
    end
    
    local newgameBtn = ccui.Button:create("star/newgame.png","","")
    newgameBtn:setPosition(basePos.x,basePos.y)
    layer:addChild(newgameBtn,1)
    newgameBtn:addTouchEventListener(newgameBtnEvent)
    
    local resumeBtn = ccui.Button:create("star/resume.png","","")
    resumeBtn:setPosition(basePos.x,newgameBtn:getPositionY()-resumeBtn:getContentSize().height-gap)
    layer:addChild(resumeBtn,1)
    resumeBtn:addTouchEventListener(resumeBtnEvent)
    
    local helpBtn = ccui.Button:create("star/help.png","","")
    helpBtn:setPosition(basePos.x,resumeBtn:getPositionY()-helpBtn:getContentSize().height-gap)
    layer:addChild(helpBtn,1)
    helpBtn:addTouchEventListener(helpBtnEvent)
    
    local exitBtn = ccui.Button:create("star/exit.png")
    exitBtn:setPosition(basePos.x,helpBtn:getPositionY()-exitBtn:getContentSize().height-gap)
    layer:addChild(exitBtn,1)
end







