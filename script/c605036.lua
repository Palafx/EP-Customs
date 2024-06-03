--Sunfire Golem
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--triple tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e2:SetValue(s.condition)
	c:RegisterEffect(e2)
	--Take 2000 damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--Gain LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCost(aux.bfgcost)
	e4:SetCondition(s.recon)
	e4:SetTarget(s.retg)
	e4:SetOperation(s.reop)
	c:RegisterEffect(e4)
end
s.listed_names={CARD_RA,id}
--special summon proc 
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local oprg=Duel.GetReleaseGroup(1-tp)
	local rg=Duel.GetReleaseGroup(tp)
	local g=oprg:Clone()
	g:Merge(rg)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and #oprg>1 and #rg>0 and #g>2 
		and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local oprg=Duel.GetReleaseGroup(1-tp,false,true)
	local rg=Duel.GetReleaseGroup(tp)
	local osg=aux.SelectUnselectGroup(oprg,e,tp,2,2,s.rescon,1,tp,HINTMSG_RELEASE,nil,nil,true)
	local sg=aux.SelectUnselectGroup(rg,e,tp,1,1,s.rescon,1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #sg>0 and #osg>1 then
		sg:KeepAlive()
		osg:KeepAlive()
		local rrg=sg:Merge(osg)
		e:SetLabelObject(rrg)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
--triple tribute
function s.condition(e,c)
	return c:IsAttribute(ATTRIBUTE_DIVINE)
end
--damage
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--gain lp 
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.filter),tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c)
	return c:IsCode(CARD_RA) or c:ListsCode(CARD_RA)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,4000)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end