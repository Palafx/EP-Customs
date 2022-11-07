--Ram, The Oni Twins Maid
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c,false)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
  --Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(s.addcon)
	c:RegisterEffect(e3)
  --To Extra
  local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetCondition(s.excon)
	e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1,{id,2})
	e4:SetTarget(s.tetg)
	e4:SetOperation(s.teop)
	c:RegisterEffect(e4)
end
s.listed_names={25258742}
--place rem on pzone
function s.pcfilter(c,code)
	return c:IsCode(code) and not c:IsForbidden()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_DECK,0,nil,25258745)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.GetFirstMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,nil,25258745)
		if not tc then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--place rem on extra
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,1,nil,25258745) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
  --Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
  local g=Duel.GetFirstMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,nil,25258745)
  return Duel.SendtoExtraP(g,tp,REASON_EFFECT)
end
--to extra
function s.sufilter(c,e)
  return c:IsCode(25258745)
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.sufilter,1,nil)
end
function s.filter(c)
  return c:IsType(TYPE_PENDULUM) and Card.ListsCode(c,25258742)
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
  local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
  if #g>0 then
    Duel.SendtoExtraP(g,tp,REASON_EFFECT)
  end
end