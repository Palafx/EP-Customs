--Battlewasp - Tank the Hazard
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),2,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Draw / Burn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.zptcon(nil))
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	e2:SetCountLimit(1,{id,2})
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={SET_BATTLEWASP}
--link summon
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function s.thfilter(c)
	return c:IsSetCard(SET_BATTLEWASP) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_BATTLEWASP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE|LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE|LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
----draw / Burn
--synchro check
s.synfilter=aux.FaceupFilter(Card.IsType,TYPE_SYNCHRO)
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroup():IsExists(s.synfilter,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	local ttatk=g:GetSum(Card.GetAttack)
	Duel.Damage(1-tp,ttatk/2,REASON_EFFECT)
end
s.lvfilter=aux.FaceupFilter(Card.IsLevelBelow,4)
--level check
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroup():IsExists(s.lvfilter,1,nil) end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--operations
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.syntg(e,tp,eg,ep,ev,re,r,rp,0) or s.lvtg(e,tp,eg,ep,ev,re,r,rp,0) end
	if s.syntg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.syntg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if s.lvtg(e,tp,eg,ep,ev,re,r,rp,0) then
		s.lvtg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,1,tp,2)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if s.lvtg(e,tp,eg,ep,ev,re,r,rp,0) then 
		Duel.BreakEffect()
		s.lvop(e,tp,eg,ep,ev,re,r,rp)
	end
	if s.syntg(e,tp,eg,ep,ev,re,r,rp,0) then 
		Duel.BreakEffect()
		s.synop(e,tp,eg,ep,ev,re,r,rp)
	end
end