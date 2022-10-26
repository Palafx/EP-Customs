--Vanilla Valley
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(s.tftg)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
  --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tg)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--Def
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e3:SetValue(1)
	c:RegisterEffect(e3)
  --decrease tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetCondition(s.ntcon)
	e5:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e5)
	--extra summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e6:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	c:RegisterEffect(e6)
end
--add and place
function s.thfilter(c)
	return c:IsCode(21862633) or (c:IsMonster() and c:IsType(TYPE_NORMAL)) and c:IsAbleToHand()
end
function s.tffilter(c,tp)
	return c:IsCode(35762283) and not c:IsForbidden()
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if (not e:GetHandler():IsRelateToEffect(e)) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	  local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	  if tc then
		  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  end
	end
end
--gain tk
function s.tg(e,c)
	return c:IsType(TYPE_NORMAL)
end
function s.filter(c)
	return c:IsType(TYPE_NORMAL)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
--decrease lv
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(5)
end