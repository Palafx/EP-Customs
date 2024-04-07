--Emergency Support Gate
--scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate and Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
s.listed_names={92035412,id}
s.listed_series={SET_VYLON}
--set
function s.filter(c)
	return c:IsCode(92035412) and c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,1,1,nil)
	Duel.SSet(tp,g:GetFirst())
	end
end
--recover
function s.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_VYLON) and c:IsSpell()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(s.recfilter,tp,LOCATION_STZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(s.recfilter,p,LOCATION_STZONE,0,nil)
	if ct>0 then
		Duel.Recover(p,ct*200,REASON_EFFECT)
	end
end