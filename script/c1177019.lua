--Cor, The Adaptive King Of Geysers
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--Fusion Materials
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--To top of Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_series={0x499}
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
--to deck
s.toss_coin=true
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=eg:Filter(aux.AND(Card.IsSummonPlayer,Card.IsAbleToDeck),nil,1-tp)
  if chk==0 then return not eg:IsContains(e:GetHandler()) and #g>0 end
  Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetTargetCard(g)
end
function s.filter(c,e,tp)
  return c:IsSummonPlayer(1-tp) and c:IsRelateToEffect(e) and c:IsAbleToDeck()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
  local g=eg:Filter(s.filter,nil,e,tp)
  if #g>0 then
    --announce coin and return
    if Duel.TossCoin(tp,1)==COIN_HEADS then
      Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
    end
  end
end
--fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WATER,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end