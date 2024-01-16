--Aequinox, The Adaptive King Of The Summit
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--Fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--Cannot activate Spell/Traps
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.limval)
	c:RegisterEffect(e4)
end
s.listed_series={0x499}
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
function s.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL) and not rc:IsImmuneToEffect(e)
end
-- fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WIND,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end