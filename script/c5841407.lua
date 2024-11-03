--Quantum Pilgrim - Boson Bishop
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon procedure
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PSYCHIC),4,2)
	--Special Summon 1 "Quantum Pilgrim" monster from the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,2})
	e2:SetCondition(function(e) return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xc58) end)
	e2:SetCost(s.atkcost)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--Attach 1 banished card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(aux.dxmcostgen(1,1,nil))
	e3:SetCountLimit(1,{id,3})
	e3:SetCondition(s.ovcon)
	e3:SetTarget(s.ovtg)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_series={0xc58}
--special summon 
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc58) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xc58) and c:IsLocation(LOCATION_EXTRA)
end
--atk boost
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--Gains ATK until the end phase
		local val=Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandler():GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,1)
		c:RegisterEffect(e1)
	end
end
--attach 
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0
end
function s.ovfilter(c,e,xc,tp)
	return c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_REMOVED) and not c:IsImmuneToEffect(e)
		and c:IsCanBeXyzMaterial(xc,tp,REASON_EFFECT)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and eg:IsExists(s.ovfilter,1,nil,e,c,tp) end
	Duel.SetTargetCard(eg)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) or c:IsImmuneToEffect(e) then return end
	local tg=Duel.GetTargetCards(e):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
	local g=tg:FilterSelect(tp,s.ovfilter,1,1,nil,e,c,tp)
	if #g>0 then
		Duel.Overlay(c,g)
	end
end