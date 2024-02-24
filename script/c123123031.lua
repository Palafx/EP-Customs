--Star Seraph Vanguard
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3,nil,nil,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
--atk
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end
--replacement
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
--burn
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Recover(tp,500,REASON_EFFECT)
end
--destroy
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) 
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local rt=Duel.GetTargetCount(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if rt>3 then rt=3 end
	local ct=Duel.DiscardHand(tp,nil,1,rt,REASON_DISCARD+REASON_COST)
	e:SetLabel(ct)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #rg>0 then
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
