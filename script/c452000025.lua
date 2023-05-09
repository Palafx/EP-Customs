--Parasitic Outbreak
--Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x53d}
s.listed_names={id}
--if opp has 5+ cards in hand and all are level 2 "Parasit" monsters
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local n1=g:FilterCount(s.pfilter,nil)
	local n2=g:FilterCount(s.ownfilter,nil,tp)
	return n1>0 and n2==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>=5
end
--"parasit"monsters currently in opp hand
function s.pfilter(c)
  return c:IsPublic() and c:IsSetCard(0x53d) and c:IsLevel(2)
end
--cardsopp owns
function s.ownfilter(c,tp)
  return c:GetOwner()==1-tp
end
--monsters to add to opp hand
function s.filter(c)
	return c:IsLevel(2) and c:IsSetCard(0x53d) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ALL,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ALL,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ALL)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,Duel.GetFieldGroup(tp,0,LOCATION_HAND),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,300)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--send "parasit"monsters everywhere to opp hand
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ALL,0,nil)
	if #g>0 then
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		--opp gains 400 LP for each card added
		local tgop=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local tct=ct*400
		local exct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
		--add the top cards of opp hand to own hand
		local gt=Duel.GetDecktopGroup(1-tp,ct)
		--add cards from opp extra to own
		local gex=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.BreakEffect()
		if gt and gex then
		Duel.SendtoHand(gt,tp,REASON_EFFECT) --add opp's cards to own hand
		Duel.ConfirmCards(tp,gex)
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		--local exx=gex:FilterSelect(tp,Card.IsAbleToRemove,1,ct,nil,tp,POS_FACEDOWN)
		Duel.Sendto(gex,LOCATION_EXTRA,0,REASON_EFFECT)
		Duel.Recover(1-tp,tct,REASON_EFFECT) --opp gains lp
		Duel.SendtoDeck(tgop,1-tp,0,REASON_EFFECT) --opp returns hand to deck
		Duel.SendtoDeck(tg,tp,0,REASON_EFFECT) --player returns hand to own deck
		Duel.ShuffleDeck(1-tp) --shuffle opp deck
		Duel.ShuffleDeck(tp) --shuffle own deck
		end
	end
end