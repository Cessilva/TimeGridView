function init() 
    m.btn = m.top.findNode("btn")
    m.top.observeField("focusedChild", "OnChildFocused")
end function

sub OnChildFocused()
?"Me pasaron el focus"
    if m.top.isInFocusChain() and not m.btn.hasFocus() then
        m.btn.setFocus(true)
    end if
end sub