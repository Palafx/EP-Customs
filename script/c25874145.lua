--Battlewasp - Blade the Battallion
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	--Special Summon monsters 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_BATTLEWASP))
	e2:SetValue(function(e,c) return math.abs((Duel.GetLP(1)-Duel.GetLP(0))/3) end)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={SET_BATTLEWASP}
--summon
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.spfilter(c,e,tp,val)
    return c:IsSetCard(SET_BATTLEWASP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttackBelow(val)
end
function s.rescon(val)
	return	function(sg,e,tp,mg)
				local res=sg:GetSum(Card.GetAttack)<=val
				return res, not res
			end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local val=e:GetLabel()==1 and math.abs(Duel.GetLP(tp)-1000-Duel.GetLP(1-tp)) or math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,val)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local val=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,val)
	if #g==0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,math.min(#g,ft),s.rescon(val),1,tp,HINTMSG_SPSUMMON)
	if #sg==0 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end