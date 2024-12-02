--Rainbow Jar
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) or Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(1-tp,aux.Stringid(id,0),aux.Stringid(id,1))
	e:SetLabel(op)
	if op==0 then --player mills
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 then
			local sg=aux.SelectUnselectGroup(g,e,tp,1,6,aux.dpcheck(Card.GetAttribute),1,tp,HINTMSG_TOGRAVE)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Draw(1-tp,2,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_DECK,nil)
		if #g>0 then
			local sg=aux.SelectUnselectGroup(g,e,tp,1,6,aux.dpcheck(Card.GetAttribute),1,1-tp,HINTMSG_TOGRAVE)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end