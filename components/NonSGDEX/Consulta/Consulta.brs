Function Init()
    ? "[ScreenConsulta] Init"  
    m.LabelInfo        = m.top.findNode("LabelInfo")
    m.testPoster       = m.top.findNode("testPoster")
    m.LabelInfo.text=m.top.content
End Function
sub render()
    medidaLabelInfo=m.LabelInfo.boundingRect()
    medidatestPoster=m.testPoster.boundingRect()
    m.LabelInfo.translation=[((1280-medidaLabelInfo.width)/2),m.top.heightConsulta+50]
    m.testPoster.translation=[((1280-medidatestPoster.width)/2),m.top.heightConsulta+medidaLabelInfo.height+60]
end sub
sub CambiaOrientacion()
if m.top.orientation=true then 
     m.testPoster.uri="pkg:/images/flechaArriba.png" 
else
 m.testPoster.uri="pkg:/images/flechaAbajo.png"
end if 
end sub 
