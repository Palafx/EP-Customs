--Star Seraph Ark
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon or attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetTarget(s.attg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	--Special Summon from hand or gy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--get effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e4:SetCountLimit(1)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
s.listed_names={id}
s.listed_series={0x86}
--special summon
function s.attfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ca=e:GetHandler()
  if chk==0 then return Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,e) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and ca:IsCanBeSpecialSummoned(e,0,tp,false,false)) end
  Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ca,1,0,0)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local spchk=ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local attchk=Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,e)
	if not (spchk or attchk) then return end
	if Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,e) then
		local op=Duel.SelectEffect(tp,{spchk,aux.Stringid(id,3)},{attchk,aux.Stringid(id,4)})
		if op==1 then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local oc=Duel.SelectMatchingCard(tp,s.attfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
			if oc then
				Duel.HintSelection(oc,true)
				Duel.Overlay(oc,c)
			end
		end
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--sp summon from hand or gy
function s.spfilter(c,e,tp,lvl,rc)
	return c:IsSetCard(0x86) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.xyzfilter(c)
	return c:IsXyzSummonable()
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) 
		and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) then
		local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst())
		end
	end
end
--grant eff
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1)
	and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end