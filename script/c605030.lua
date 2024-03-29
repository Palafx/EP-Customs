--Deckplanning
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g==0 then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if #g>0 then
		g=g:Select(tp,1,ct,nil)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ag1=g:Select(tp,1,1,nil)
		Duel.SendtoHand(ag1,tp,REASON_EFFECT)
		local thc=Duel.GetOperatedGroup()
		if #thc>0 and Duel.IsPlayerCanDraw(1-tp,#g) and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Draw(1-tp,#g,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end