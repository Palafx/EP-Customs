--Dicebound Enchanted Labyrinth
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.spfilter(c,e,tp,tc)
	local own=tc:GetOwner()
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,own,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local own=tc:GetOwner()
	if d==1 then
		if Duel.SelectYesNo(own,HINTMSG_SPSUMMON) and Duel.GetLocationCount(own,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,own,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(own,s.spfilter,own,0x13,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,own,tp,false,false,POS_FACEUP)
			end
		end
	elseif d>1 and d<11 then
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_LINK) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	elseif d>10 and d<20 then
		if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	else
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end