--Amorphage Conversion
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.tgg)
	c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={SET_AMORPHAGE}
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3392890,SET_AMORPHAGE,TYPES_TOKEN,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH)
		and Duel.CheckLPCost(tp,2000) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.filter(c)
	return c:IsSetCard(SET_AMORPHAGE) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>6 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.tgg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local b1=s.tktg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=s.destg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		e:SetProperty(0)
		e:SetOperation(s.tkop)
		s.tktg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(s.desop)
		s.destg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end

function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,3392890,SET_AMORPHAGE,TYPES_TOKEN,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) then return end
	Duel.PayLPCost(tp,2000)
	local c=e:GetHandler()
	for i=1,2 do
		local token=Duel.CreateToken(tp,3392890)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		--Cannot special summon from extra deck while you control this token
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetRange(LOCATION_MZONE)
				e3:SetAbsoluteRange(tp,1,0)
				e3:SetTarget(s.splimit)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e3)
				--Clock Lizard check
				local e4=aux.createContinuousLizardCheck(e:GetHandler(),LOCATION_MZONE)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e4,true)
	end
	Duel.SpecialSummonComplete()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end