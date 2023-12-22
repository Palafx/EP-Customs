--Hieratic Superior Dragon Overlord of Heliopolis
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,nil,8,2,nil,nil,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--Gains effects based on material.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,2})
	e2:SetLabel(0)
	e2:SetCondition(s.regcon)
	e2:SetTarget(s.regtg)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
end
--s.listed_series={}
s.listed_names={13140300,id}
--special summon
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
--gain effects
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()>0
end
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local effs=e:GetLabel()
	if chk==0 then return ((effs&1)>0 and Duel.IsPlayerCanDraw(tp,1)) or ((effs&2)>0) end
	if (effs&1)>0 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local effs=e:GetLabel()
	--1
	if effs<2 then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.val)
		c:RegisterEffect(e1)	
	end
	--2
	if effs<3 then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.val)
		c:RegisterEffect(e1)	
		--"Hieratic" monsters cannot be destroyed by card effects 
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(function(e,c) return c:IsSetCard(0x69) end)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if effs==3 then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.val)
		c:RegisterEffect(e1)	
		--"Hieratic" monsters cannot be destroyed by card effects 
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(function(e,c) return c:IsSetCard(0x69) end)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local effs=0
	if g:IsExists(Card.IsCode,1,nil,13140300) then effs=1 end
	if g:IsExists(Card.IsCode,2,nil,13140300) then effs=2 end
	if g:IsExists(Card.IsCode,3,nil,13140300) then effs=3 end
	e:GetLabelObject():SetLabel(effs)
end
--atk up
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_DRAGON)*100
end
--draw
function s.drfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.drfilter,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end