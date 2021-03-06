--Invocyte Script Token
local m=888101
local cm=_G["c"..m]
function cm.initial_effect(c)
    --copy effect
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetRange(LOCATION_HAND)
    e0:SetCountLimit(1)
    e0:SetCost(cm.ecost)
    e0:SetTarget(cm.etg)
    e0:SetOperation(cm.eop)
    c:RegisterEffect(e0)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(cm.USfilter)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,m)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(cm.dtgtg)
    e3:SetOperation(cm.dtgop)
    c:RegisterEffect(e3)
end
--filters
function cm.dtgfilter(c)
    return c:IsSetCard(0xff8) and c:IsAbleToGrave()
end
function cm.filter(c,e)
    return c:IsSetCard(0xff8) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function cm.USfilter(e,te)
    return (te:IsActiveType(TYPE_SPELL)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.UMfilter(e,te)
    return (te:IsActiveType(TYPE_MONSTER)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.UTfilter(e,te)
    return (te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--copy effect
function cm.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,e) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e) end
    Duel.Hint(HINT_SELECTMSG,tp,HINSTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsFaceup() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
    local code=e:GetHandler():GetOriginalCode()
    tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
    if not tc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2,true)
    end
end
--send to GY
function cm.dtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.dtgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end