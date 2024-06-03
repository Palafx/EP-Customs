--Dicebound Arcane Diviner
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Toss a coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.dicetg)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.roll_dice=true
--coin
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CallCoin(tp) then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
			Duel.SortDecktop(tp,tp,3)
		end
	else
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if #g==0 then return end
			local sg=g:RandomSelect(ep,1)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleHand(1-tp)
		end
	end
end
--dice
function s.rfilter(c)
	return c:IsSetCard(0xc59) and c:IsSpellTrap()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc59) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	if d==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_DECK|LOCATION_HAND,0,2,2,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif d>1 and d<11 then
		if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
		Duel.ConfirmDecktop(tp,1)
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		if tc:IsSpellTrap() and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc,REASON_EFFECT|REASON_EXCAVATE)
		end
	elseif d>10 and d<20 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end