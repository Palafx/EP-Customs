--Viper Hunting
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Search 3 "Venom" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.ngcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.ngtg)
	e2:SetOperation(s.ngop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={SET_VENOM}
s.counter_list={COUNTER_VENOM}
s.counter_place_list={COUNTER_VENOM}
--activate
function s.thfilter(c)
	return c:IsSetCard(SET_VENOM) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>=3 and aux.SelectUnselectGroup(g,e,tp,3,3,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	local thg=aux.SelectUnselectGroup(g,e,tp,3,3,nil,1,tp,HINTMSG_ATOHAND)
	if #thg>0 then
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end
--negate
function s.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if #tg~=1 or not tc:IsCode(54306223) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function s.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.ngop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
	Duel.BreakEffect()
	local g=Group.CreateGroup()
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		if tc:IsCanAddCounter(COUNTER_VENOM,1) and not tc:IsSetCard(SET_VENOM) then
			local atk=tc:GetAttack()
			tc:AddCounter(COUNTER_VENOM,1)
		end
	end
end