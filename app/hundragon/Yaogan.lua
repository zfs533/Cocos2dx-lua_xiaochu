local Yaogan = class("Yaogan",ccui.ImageView)

function Yaogan:ctor(pt)
    self.direction = 0
	self:loadTexture("henban/hero/yaogan/yaokong_2.png")
	local function test(target,state)
	   if state == ccui.TouchEventType.began then
            self.hand:setOpacity(255)
            local strPos = target:getTouchBeganPosition()
            self.hand:setPosition(strPos)
	   elseif state == ccui.TouchEventType.moved then
	       local movPos = target:getTouchMovePosition()
	       local tempD = cc.pGetDistance(movPos,self.centerP)
	       if tempD >= self.centerD then
	           tempD = self.centerD
	       end
	       local radius = math.atan2(movPos.y-self.centerP.y,movPos.x - self.centerP.x)
           local angle = radius/math.pi*180
           self.angle = angle
	       local p = cc.p(math.cos(radius),math.sin(radius))
	       self.hand:setPosition(p.x*tempD+self.centerP.x,p.y*tempD+self.centerP.y)
           self.isStartMove = true
       else
            self.isStartMove = false
            self.hand:setOpacity(0)
            self:stopMove()
	   end
	end
	
	self:setTouchEnabled(true)
	self:addTouchEventListener(test)
	self:initHand()
	local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:scheduleScriptFunc(function() self:startMove() end, 0.02,false)
end

function Yaogan:setPt(pt)
    self.PT = pt
end

function Yaogan:initHand()
    local centerP = cc.p(self:getContentSize().width/2,self:getContentSize().height/2)
    local centerD = cc.pGetDistance(cc.p(0,0),centerP)
    local hand = cc.Sprite:create("henban/hero/yaogan/yaokong_1.png")
    hand:setPosition(centerP)
    hand:setOpacity(0)
    self:addChild(hand)
    self.hand = hand
    self.centerP = centerP    
    self.centerD = centerD
    self.angle = 0
    self.isStartMove = false
end

function Yaogan:startMove()
    if self.isStartMove then
        local angle = self.angle
        if angle <= 45 and angle >= -45 then
            self.direction = 1
            self.PT:runForword()
            self.PT:changeActionTexture(0)
        elseif angle >= 135 or angle <=-135 then
            self.direction = -1
            self.PT:runBack()
            self.PT:changeActionTexture(0)
        elseif angle >45 and angle < 135 then
            if angle <= 90 then
                self.direction = 1
            elseif angle >90 and angle < 135 then
                self.direction = -1
            end
            self.PT:changeActionTexture(1)
            self.PT:startJump(self.direction)
        elseif angle <-45 and angle >-135 then
            self.PT:changeActionTexture(2)
        end
    end
end

function Yaogan:stopMove()
    self.PT:changeActionTexture(3)
end

return Yaogan









