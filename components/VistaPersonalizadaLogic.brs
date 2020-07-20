sub ShowVistaPersonalizada(content as string)
m.VistaPersonalizada = CreateObject("roSGNode", "VistaPersonalizada")
m.VistaPersonalizada.text=content
m.top.ComponentController.callFunc("show", {
    view: m.VistaPersonalizada
})
end sub
