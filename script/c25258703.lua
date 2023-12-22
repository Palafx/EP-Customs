--Hieratic Dragon of Rituals
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--If tributed, special summon 1 dragon normal monster from hand, deck, or GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
s.listed_names={id}
--special summon self
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,5) end
	Duel.DiscardDeck(tp,5,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local c=e:GetHandler()
		--Cannot Special Summon for the rest of this turn, except Dragon monsters
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(id,1))
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetTargetRange(1,0)
		e0:SetTarget(function(_,c) return not c:IsRace(RACE_DRAGON) end)
		e0:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e0,tp)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--special summon normal
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end