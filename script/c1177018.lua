--Pontifex, The Adaptive Queen Of Cosmos
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--Fusion Materials
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--Cannot Special Summon from Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
end
s.listed_series={0x499}
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
--cannot sp summon	
function s.splimit(e,c)
	if e:GetHandler():GetFlagEffect(id)>0 then e:GetHandler():ResetFlagEffect(id) return false end
	return c:IsLocation(LOCATION_EXTRA)
end
--fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end