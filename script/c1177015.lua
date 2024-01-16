--Botan, The Adaptive Queen Of Plasma
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--Cannot add or draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.con)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e3)
end
s.listed_series={0x499}
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
function s.con(e)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
-- fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WIND,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end