--Adaptive Trait - Acclimation
--Scripted By EP Custom Cards and Naim
local s,id=GetID()
function s.initial_effect(c)
local e0=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x499))
 --Unaffected by same Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetRange(LOCATION_SZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--unaffected
function s.efilter(e,te)
  local at=e:GetHandler():GetEquipTarget():GetAttribute()
  return te:IsMonsterEffect() and te:GetHandler():IsAttribute(at)
end
--draw
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end