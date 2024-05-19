--Boot-Up Order - Gear Sequence
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--gain effects
		--yellow
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(3001)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.indestg1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
		--red
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(3002)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.indestg2)
	e4:SetValue(1)
	c:RegisterEffect(e4)
		--green
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(3000)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.indestg3)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Normal
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_HAND)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.nscon)
	e6:SetTarget(s.nstg)
	e6:SetOperation(s.nsop)
	c:RegisterEffect(e6)
end
s.listed_series={0x51}
s.listed_names={13839120,86445415,41172955}
--gain atk
function s.val(e,c)
	return c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x51)*300
end
function s.filter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x51)
end
--gain effects
function s.yellow(c)
  return c:IsCode(13839120)
end
function s.indestg1(e,c)
	return c:GetEquipCount(s.yellow)>0
end
function s.red(c)
  return c:IsCode(86445415)
end
function s.indestg2(e,c)
	return c:GetEquipCount(s.red)>0
end
function s.green(c)
  return c:IsCode(41172955)
end
function s.indestg3(e,c)
	return c:GetEquipCount(s.green)>0
end
--Normal
function s.cfilter(c,tp)
	return c:IsMonster() and (c:IsSetCard(0x7) or c:IsSetCard(0x51)) and c:IsControler(tp)
		and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function s.nscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.nsfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSummonable(true,nil)
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
