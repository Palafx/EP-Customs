--Sinister Sire of Chance
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if chk==0 then return #g1~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g<2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(tp)
	elseif d==2 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g<2 then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=g:Select(1-tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	elseif d==3 then
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif d==4 then
		Duel.Draw(tp,2,REASON_EFFECT)
	elseif d==5 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,2,2,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	else
		local d=Duel.TossDice(tp,1)
		if d==6 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if chk==0 then return #g>0 end
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
