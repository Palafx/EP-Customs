--Forbidden Web Code: Exodia Protocol
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	-- Link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2,s.lcheck)
	--Unaffected by other card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.winop)
	c:RegisterEffect(e3)
end
s.listed_names={2760520,2760521,2760522,2760523}
s.listed_series={SET_FORBIDDEN_ONE}
--link material
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x40,lc,sumtype,tp)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--WIN
function s.cfilter3(c)
	local webcon={2760520,2760521,2760522,2760523}
	return c:IsFaceup() and c:IsCode(table.unpack(webcon))
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter3,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g:GetClassCount(Card.GetCode)==4 then
		Duel.Win(tp,0x59)
	end
end