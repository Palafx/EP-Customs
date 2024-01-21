--Moltanis, The Adaptive King Of Brimstone
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.unifilter),LOCATION_MZONE)
	--Fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e1)
	--Burn after a Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetCondition(s.atkcon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Burn after activation of a Spell/Trap
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(s.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.damcon)
	e6:SetOperation(s.damop)
	c:RegisterEffect(e6)
	--damage conversion
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_REVERSE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(s.rev)
	c:RegisterEffect(e7)
end
s.listed_series={0x499}
s.material_setcode=0x499
function s.rev(e,re,r,rp,rc)
	return (r&REASON_EFFECT)~=0
end
--unique
function s.unifilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x499)
end
--fusion materials
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsSetCard(0x499,fc,sumtype,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(id)~=0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
   	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end