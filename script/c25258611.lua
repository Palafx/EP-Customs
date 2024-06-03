--Dicebound Mirage Illusion
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.dicetg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	if d==1 then
		if Duel.NegateActivation(ev) then
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
			if #g==0 then return end
			local rg=g:RandomSelect(tp,1)
			if #rg>0 then
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	elseif d>1 and d<11 then
		Duel.NegateActivation(ev)
	elseif d>10 and d<20 then
		if Duel.NegateActivation(ev) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsSpellTrap,tp,0,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end