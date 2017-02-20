
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

--require "app.star.Star"



function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    local sp = cc.Sprite:create("resoures/card/zhan_jiang_yuji.png")
    sp:setPosition(100,100);
    self:addChild(sp);

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
    local spriteFrame  = cc.SpriteFrameCache:getInstance()  
    spriteFrame:addSpriteFrames("star/blink.plist") 
    
    local function starTouchEvent(target,state)
    	if state == ccui.TouchEventType.ended then 
    	   print(target:getStarType())
    	end
    end
    print("--------------------------------------------------------")
   
    
    
    
    
    print("--------------------------------------------------------")
    local function btnEvent(target,state)
        if state == ccui.TouchEventType.ended then
--            local moveBy = cc.MoveBy:create(0.5,cc.p(50,50))
--            local elastic = cc.EaseBackOut:create(moveBy);
--            sp:runAction(elastic)        
        local scene = CreateWelcomeScene()
            local trans = cc.TransitionFade:create(1,scene)
            cc.Director:getInstance():replaceScene(trans)
--            local star = Star:createStar("star/blink1.png",10)
--            star:setPosition(100,100)
--            self:addChild(star)
--            star:addTouchEventListener(starTouchEvent)
            
        end
    end
    local btn = ccui.Button:create("resoures/CloseNormal.png","resoures/CloseSelected.png","")
    self:addChild(btn,1000)
    btn:setPosition(100,300)
    btn:addTouchEventListener(btnEvent)

end

return MainScene

--local scene = CreateWelcomeScene()
--            local trans = cc.TransitionFade:create(1,scene)
--            cc.Director:getInstance():replaceScene(trans)
