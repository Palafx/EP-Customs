--- Parasite Pupa
--- Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
  --Link Summon
  Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x53d),2,2)
  c:EnableReviveLimit()
  --Cannot Attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
  --Halve Damage
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
  e2:SetValue(aux.ChangeBattleDamage(0,HALF_DAMAGE))
  c:RegisterEffect(e2)
  --Indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
s.listed_series={0x53d}