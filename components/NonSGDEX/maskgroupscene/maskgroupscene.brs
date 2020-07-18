sub init()
      m.poster = m.top.findNode("examplePoster")
      m.dx=0
      m.dy=0
      m.top.setFocus(true)
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if press then
    if (key = "back") then
      handled = false
    else if (key = "OK") then
        print "hola"
      handled = true
    else if (key="left")
        print key
         if m.dx=0 then
            m.dy=m.dy-1
            m.dx=10
            anteriory=m.poster.translation[1]
            m.poster.translation=[-1798,anteriory+(2024/18)]  
        else 
        ?"salto de izquierda hacia arriba"
            m.dx=m.dx-1
            anteriorx= m.poster.translation[0]
            m.poster.translation=[anteriorx+200,m.poster.translation[1]] 
        end if
        handled = true
    else if (key="right")
        if m.dx<9 then
            m.dx=m.dx+1
            anteriorx= m.poster.translation[0]
            m.poster.translation=[anteriorx-200,m.poster.translation[1]]
        else
            ?"salto de derecha hacia abajo"
            m.dy=m.dy+1
            m.dx=0
            anteriory=m.poster.translation[1]
            anteriorx=m.poster.translation[0]
            print anteriorx
            m.poster.translation=[0,anteriory-(2024/18)]
        end if
        handled = true
    end if
  end if
  return handled
end function