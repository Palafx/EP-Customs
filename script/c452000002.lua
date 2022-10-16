--- Parasite Paragor
local s,id=GetID()
function s.initial_effect(c)
-- Send Itself to the Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOKEN)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCost(s.cost)
  e1:SetTarget(s.target)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)
  Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
  local e2=e1:Clone()
  e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e2)
  local e3=e1:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
-- Take Control of Opponent Monster
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id,0))
  e4:SetCategory(CATEGORY_CONTROL)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCondition(s.tgcon)
  e4:SetTarget(s.tgtg)
  e4:SetOperation(s.tgop)
  c:RegisterEffect(e4)
end
--can only special summon insects
function s.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
--to hand
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,1-tp,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH) then
  Duel.BreakEffect()
  local token=Duel.CreateToken(tp,982198099)
  Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
end
--take control
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and e:GetHandler():IsPreviousControler(1-tp)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
  if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
  tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
  if tc then
    Duel.GetControl(tc,tp)
  end
end