--Huggin & Munnin, Avatars of the Generaider Boss
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--draw and discard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,2})
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,1})
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={SET_GENERAIDER}
--cannot target
function s.tgtg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(SET_GENERAIDER)
end
--draw
function s.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_GENERAIDER)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.ShuffleHand(tp)
	end
	if h2>0 then 
		Duel.ShuffleHand(1-tp)
		if Duel.IsExistingMatchingCard(s.recfilter,tp,LOCATION_FZONE,0,1,nil) then
			Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
--draw
function s.cfilter(c)
	return c:IsSetCard(SET_GENERAIDER)
end
function s.spcheck(sg,tp)
	return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,#sg,sg)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.disfilter,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.disfilter,1,2,false,nil,nil,tp)
	local ct=Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end