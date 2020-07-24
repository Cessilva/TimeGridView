sub ShowVistaPersonalizada(texto as string)
m.VistaPersonalizada = CreateObject("roSGNode", "VistaPersonalizada")
content = CreateObject("roSGNode", "ContentNode")
m.VistaPersonalizada.text=texto
m.VistaPersonalizada.content = content
m.top.ComponentController.callFunc("show", {
    view: m.VistaPersonalizada
})
end sub
