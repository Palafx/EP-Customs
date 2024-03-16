--AOJ Upgrade Module
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,SET_ALLY_OF_JUSTICE))
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--AOJ Catastor: opponent cannot activate during BP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.catcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--AOJ Light Gazer: piercing
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetCondition(s.lgcon)
	c:RegisterEffect(e3)
	--AOJ Field Marshal
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetCondition(s.fmcon)
	c:RegisterEffect(e4)
	--AOJ Decisive Armor
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetCondition(s.dacon)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
end
s.listed_names={id,26593852,19204398,}
s.listed_series={SET_ALLY_OF_JUSTICE}
--unaffected
function s.efilter(e,te)
	local c=te:GetHandler()
	return c:GetAttribute()==ATTRIBUTE_LIGHT
end
--Catastor
function s.catcon(e)
	local ph=Duel.GetCurrentPhase()
	local tc=e:GetHandler():GetEquipTarget()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and tc and tc:IsCode(26593852)
end
--Light Gazer
function s.lgcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsCode(19204398)
end
--Field Marshal
function s.fmcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsCode(69461394)
end
--Decisive Armor
function s.dacon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsCode(9888196) 
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end