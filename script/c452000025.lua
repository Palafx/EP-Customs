--Parasitic Outbreak
--Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_DRAW_PHASE)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(s.condition)
	e0:SetTarget(s.target2)
	e0:SetOperation(s.activate2)
	c:RegisterEffect(e0)
	--GY Effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x53d}
s.listed_names={id,452000008}
--if opp has 5+ cards in hand and all are level 2 "Parasit" monsters
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local n1=g:FilterCount(s.pfilter,nil)
	local n2=g:FilterCount(s.ownfilter,nil,tp)
	return n1>4 and n2<=(n1/2) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>=5
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
function s.tgfilter(c)
	return c:IsLevel(2) and c:IsSetCard(0x53d) and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp)
	return c:IsCode(452000008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cfilter(c)
	return c:GetSequence()<5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 and g:FilterCount(Card.IsAbleToGrave,nil)==#g 
		and g:FilterCount(s.cfilter,nil)+Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #spg>0 then
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
--monsters to add to opp hand
function s.filter(c)
	return c:IsLevel(2) and c:IsSetCard(0x53d) and c:IsAbleToHand()
end
function s.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,Duel.GetFieldGroup(tp,0,LOCATION_HAND),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,300)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	--send "parasit" monsters everywhere to opp hand
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local gct=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		Duel.BreakEffect()
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local tct=ct*300
		local gt=Duel.GetDecktopGroup(1-tp,ct)
		Duel.BreakEffect()
		if gt and Duel.SendtoHand(gt,tp,REASON_EFFECT) then
			local ex=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_EXTRA,nil)
			if #ex==0 then return end
			local tc=ex:RandomSelect(tp,gct)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			local rex=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
			Duel.SendtoDeck(rex,tp,0,REASON_EFFECT)
			local tgop=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)--add opp's cards to own hand
			Duel.Recover(1-tp,tct,REASON_EFFECT) --opp gains lp
			Duel.SendtoDeck(tgop,1-tp,0,REASON_EFFECT) --opp returns hand to deck
			Duel.SendtoDeck(tg,tp,0,REASON_EFFECT) --player returns hand to own deck
			Duel.ShuffleDeck(1-tp) --shuffle opp deck
			Duel.ShuffleDeck(tp) --shuffle own deck
		end
	end
end