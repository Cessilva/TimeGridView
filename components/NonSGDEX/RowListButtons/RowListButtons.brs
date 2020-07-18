function init()
    m.myRowList=m.top.findNode("myRowListButtons")
    m.myRowList.content=m.top.content
    m.top.observeField("focusedChild","OnFocusedChildChange")
end function

sub OnFocusedChildChange()
    ? "[GridScreen] >> OnFocusedChildChangeAbecedario"
    if m.top.isInFocusChain() and not m.myRowList.hasFocus()  then
        m.myRowList.setFocus(true)
    end if
end sub

sub mostrarLabel()
m.myRowList.showRowLabel=[m.top.mostrarLabel]
end sub 

sub centerToFather()
width=m.top.fatherWidth
m.myRowList.itemSize=[(m.myRowList.rowItemSize[0][0]*m.top.elements+m.myRowList.rowItemSpacing[0][0]*m.top.elements),m.myRowList.rowItemSize[0][1]]
m.myRowList.translation=[((width - m.myRowList.itemSize[0]) / 2),m.top.heightComponent]
end sub

sub OnItemFocused()
    itemFocused = m.top.itemFocused
    m.top.titulo= m.myRowList.content.getChild(itemFocused[0]).title
    if itemFocused.count() = 2 then
        focusedContent = m.myRowList.content.getChild(itemFocused[0]).getChild(itemFocused[1])
        if focusedContent <> invalid then
            m.top.focusedContent = focusedContent
        end if
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
handled = false
if (not press) then
    if (key = "OK" ) then
            m.top.letra=m.top.focusedContent.title
            ' print "--------------------------------"
            ' print m.top.letra
    end if
end if
return handled
end function