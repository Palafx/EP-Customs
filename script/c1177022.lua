--Elderax, The Adaptive Entity
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Gain ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	--Cannot be material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e5:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e5)
	--Attribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(0xf|ATTRIBUTE_DARK)
	c:RegisterEffect(e6)
end
s.listed_names={id}
s.listed_series={0x499}
--special summon
function s.spfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x499) and c:IsAbleToRemoveAsCost() and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,3,3,nil,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
  if not g then return end
  local tc=g:GetFirst()
  local atk=0
  for tc in aux.Next(g) do
    local catk=tc:GetBaseAttack()
    if catk<0 then catk=0 end
    atk=atk+catk
  end
  e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,atk)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  g:DeleteGroup()
end
--atk
function s.atkfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x499)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(s.atkfilter),tp,LOCATION_REMOVED,0,nil)
	if #g>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=g:GetSum(Card.GetAttack)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetValue(atk)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e5)
	end
end