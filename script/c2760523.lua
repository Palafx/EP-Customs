--Forbidden Web Code: Left Arm
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.mfilter,1,1)
  --Unaffected by other card effects
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetValue(s.efilter)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x40,lc,sumtype,tp) and c:IsLevelBelow(3)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end