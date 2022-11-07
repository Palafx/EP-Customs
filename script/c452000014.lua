--Parasitoid Compressa
--Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
  --Link summon
  Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x53d),2,3)
  c:EnableReviveLimit()
  --Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_MAIN_END)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.target)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)
  --Special Summon Token + Add Parasite to Opponent Hand
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetTarget(s.drtg)
  e2:SetOperation(s.drop)
  c:RegisterEffect(e2)
end
--draw
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.filter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x53d) and c:IsLevel(2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 then
    local og=Duel.GetOperatedGroup()
    Duel.ConfirmCards(1-tp,og)
    Duel.BreakEffect()
    local tc=og:GetFirst()
    if og:Filter(s.filter,nil):IsContains(tc) and Duel.SendtoHand(tc,1-tp,REASON_EFFECT)~=0 then
      local rg=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
      local rc=rg:GetFirst()
      if Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_HAND,nil):IsContains(rc) then            
        Duel.SendtoGrave(rc,REASON_EFFECT+REASON_DISCARD)                
      else            
        Duel.SendtoHand(rc,tp,REASON_EFFECT)                
      end
    else
      Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)    
    end    
  end
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