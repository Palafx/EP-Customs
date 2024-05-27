--Mask Exchange
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={0xc57}
--22610082: The Mask of Remnants
--20765952: Mask of Dispel
--56948373: Mask of the Accursed
--82432018: Mask of Brutality
--57882509: Mask of Weakness
--29549364: Mask of Restrict
function s.tdfilter(c)
	return c:IsSetCard(0xc57) or c:IsCode(22610082,20765952,56948373,82432018,57882509,29549364) and c:IsAbleToDeck()
end
function s.thfilter(c,code)
	return (c:IsSetCard(0xc57) or c:IsCode(22610082,20765952,56948373,82432018,57882509,29549364) and c:IsAbleToHand()) and not c:IsCode(code)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND|LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
	if #g==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	thg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=thg:Select(tp,2,2,nil)
	if #sg2>0 then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
end