--Foresight
--Scripted by 
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--see top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.cfcon)
	e1:SetOperation(s.cfop)
	c:RegisterEffect(e1)
	--Unaffected by card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(s.efilter)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function s.efilter(e,te)
	local typ=e:GetLabelObject():GetLabel()
	--Debug.Message("The type received is "..tostring(typ))
	return te:IsActiveType(typ)
end
function s.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if #g>0 then
		local tc=g:GetFirst()
		local mask=TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP
		local typ=tc:GetType()&mask
		e:SetLabel(typ)
		Duel.ConfirmCards(tp,g)
	end
end