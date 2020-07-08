'Manejadores:
'Este es el responsable de crear los hijos del nodo raiz del arbol de contenido
'Cada hijo representa una fila del TimeGridView

sub GetContent()
    'Ha una llamada para obtener una lista de canales
    'ReadASCIIFile: This function reads the specified file and returns the data as a string.
    'ParseJSON:This function will parse a string formatted according to RFC4627 and return an equivalent BrightScript object (consisting of booleans, integer and floating point numbers, strings, roArray, and roAssociativeArray objects). If the string is not syntactically correct, Invalid will be returned.
    raw = ReadASCIIFile("pkg:/api/1_channels.json")
    json = ParseJSON(raw)

    'Se crea el arreglo de filas del canal
    rootChildren = {
        children: []
    } 

    'Se crea una funcion para cada canal del json:
    '1.-Leer el json
    '2.-Covertir a json
    '3.-Crear un nodo para el cannal y asignarle los campos de metadata
    for each channel in json
        ' make another API call to get detailed metadata for each channel
        raw = ReadASCIIFile("pkg:/api/" + channel + ".json")
        channelJSON = ParseJSON(raw)

        ' create a node for the channel and set its metadata fields
        channelNode = CreateObject("roSGNode", "ContentNode")
        channelNode.title = channelJSON.channel.call_sign

        'Major y minor son numeros enteros que traen los json
        'Ejemplo:   "major":45,"minor":3

        'Valida que sean validos para tener un formato:
        'KASW-HD 61      espacio+major
        'KASW-HD 61.1    punto+minor
        if channelJSON.channel.major <> invalid
            channelNode.title=channelJSON.channel.major.ToStr()+" " +channelNode.title 
        end if

        if channelJSON.channel.minor <> invalid
            channelNode.title=channelJSON.channel.major.ToStr()+"." + channelJSON.channel.minor.ToStr()+" " +channelNode.title
        end if

        'El ID es usado en la fila para identificar el canal 
        channelNode.id = channelJSON.object_id.ToStr()

        'Por ultimo , le agregamos la configuracion de controlador al hijo 
        'channelNode es el hijo de channelJSON
        channelNode.AddFields({
           HandlerConfigTimeGrid: {
               name: "CHRow"
           }
        })
        'al raiz le hacemos push de su hijo 
        rootChildren.children.Push(channelNode)
    end for
    'Actualizamos el nodo raiz, con todos los nodos de canal como hijos asi apareceran
    'como filas en la vista 
    m.top.content.Update(rootChildren)
end sub
