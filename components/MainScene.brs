' Copyright (c) 2019 Roku, Inc. All rights reserved.

' This is the main entry point to the channel scene.
' This function will be called by SGDEX when channel is ready to be shown.
sub Show(args as Object)
    ' create our TimeGridView
    grid = CreateObject("roSGNode", "TimeGridView")
    'Se crea la configuracion de controlador para el nodo raiz de arbol de contenido
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigTimeGrid: {
            name: "CHRoot"
        }
    })
    ' Le pasa el contenido al TimeGridView
    grid.content = content

    ' esto activará el trabajo para mostrar esta pantalla
    m.top.ComponentController.CallFunc("show",{view: grid})
    'Channel applications, however, must fire an AppLaunchComplete beacon when
    'the channel home page is fully rendered. This beacon must also be fired when 
    'video playback starts after handling a deep link
    'ES DE BUENA PROGRAMACION MANAR EL MENSAJITO Y ES DE CERTIFICACION
    m.top.signalBeacon("AppLaunchComplete")
end sub
