--- Parasitoid Chrysa
--- Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
  --Link Summon
  Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x53d),2,2)
  c:EnableReviveLimit()
  --Discard
	local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_HANDES)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_MAIN_END)
  e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(s.tgcon)
  e1:SetTarget(s.tgtg)
  e1:SetOperation(s.tgop)
  c:RegisterEffect(e1)
  --Special Summon Token + Add Parasite to Opponent Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetTarget(s.drtg)
  e2:SetOperation(s.drop)
  c:RegisterEffect(e2)
end
s.listed_series={0x53d}
--discard
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  local n1=g:FilterCount(s.pfilter,nil)
  local n2=g:FilterCount(s.ownfilter,nil,tp)
  return n1>n2
end
function s.pfilter(c)
  return c:IsPublic() and c:IsSetCard(0x53d) and c:IsLevel(2)
end
function s.ownfilter(c,tp)
  return c:GetOwner()==1-tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if #g==0 then return end
  local sg=g:RandomSelect(tp,1)
  Duel.SendtoGrave(sg,REASON_EFFECT)
end
--token + add to hand
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.gyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x53d) and c:IsLevel(2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH) then
    Duel.BreakEffect()
    local token=Duel.CreateToken(tp,982198099)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.gyfilter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end