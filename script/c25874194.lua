--- Glykraromir, The Bionic Artifice
	-- Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
--	FUSION MATERIALS
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION),aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO))
--	SPECIAL SUMMON LIMIT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--	ATTACK ALL MONSTERS
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--	NEGATE AND DESTROY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.condition)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
--	SPECIAL SUMMON MONSTERS IF DESTROYED
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id+100)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
--	GAIN 1000 LP ON END PHASE
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(s.rectg)
	e5:SetOperation(s.recop)
	c:RegisterEffect(e5)
end
	-- able to be summoned by MSF
s.miracle_synchro_fusion=true
	-- negate and destroy
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
	-- special summon monsters when destroyed
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousControler(tp) and rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.rescon(sg,e,tp,mg)
  return aux.ChkfMMZ(2)(sg,e,tp,mg)
      and sg:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,chk) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_SPSUMMON)
    if #sg>0 then
         Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
	-- gain 1000 lp
	function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	end
	function s.recop(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end 