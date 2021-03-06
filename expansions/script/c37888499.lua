--Celestian Bonds
function c37888499.initial_effect(c)
   --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,37888499+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c37888499.target)
    e1:SetOperation(c37888499.activate)
    c:RegisterEffect(e1)
end
function c37888499.thfilter(c,tp)
    local lv=c:GetOriginalLevel()
    return lv>1 and c:IsSetCard(0xebb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
        and Duel.IsExistingMatchingCard(c37888499.plfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c37888499.plfilter(c,lv)
    return c:IsSetCard(0xebb) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv-1) and not c:IsForbidden()
end
function c37888499.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=0
    if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
        and Duel.IsExistingMatchingCard(c37888499.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37888499.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,c37888499.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0
        and g1:GetFirst():IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,g1)
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g2=Duel.SelectMatchingCard(tp,c37888499.plfilter,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetLevel())
        local tc=g2:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET)
            tc:RegisterEffect(e1)
            Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
        end
    end
end