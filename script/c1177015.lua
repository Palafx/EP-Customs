--Botan, The Adaptive Queen Of Plasma
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--Cannot add or draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.con)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e3)
	--look at deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	--look at deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(function(_,tp) return Duel.IsTurnPlayer(1-tp) end)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
s.listed_series={0x499}
s.material_setcode=0x499
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
function s.con(e)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
-- fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WIND,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
--top of deck
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if opt==1 then
		Duel.MoveSequence(tc,opt)
	end
end
--hand
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if #g>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,sg)
	end
	Duel.ShuffleHand(1-tp)
end
