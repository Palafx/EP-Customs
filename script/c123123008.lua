-- Centicreep Veteris
-- Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
--Special Summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
s.listed_series={0x4cf}
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsMonster,Card.IsSetCard),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler(),0x4cf)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>=10 and g:GetClassCount(Card.GetCode)>=10
end