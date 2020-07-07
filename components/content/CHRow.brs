'MANEJADORES
'Este manejador es el responsable de crear hijos secundarios de la fila
'cada nodo hijo representa un programa en la fila
sub GetContent()
    'El id se establecio en el manejador raiz, este id establece que fila es
    id = m.top.content.id

    ' falsificaremos las marcas de tiempo con fines de demostración
    ' para que siempre se muestre contenido para la hora actual
    dt = CreateObject("roDateTime")
    now = dt.AsSeconds()
    playStart = now - (now mod 1800) - 3600

    'Hacemos la llamada al API para obtener los datos del canal
    raw = ReadASCIIFile("pkg:/api/3_guide_" + id + ".json")
    json = ParseJSON(raw)
     
    'Arreglo de los hijos del canal
    programNodes = {
        children: []
    }
    'Para cada programa del canal 
    'Se crea un json y si no existen los campos se agregan , en caso de que el campo no
    'venga del json se pone ---

        for each program in json
        ' create a node for the program and set its metadata fields
        programNode = {}
        'Titulo y el titulo del show
        if program.title <> invalid and program.title <> ""
            programNode.title = program.title
        else if program.airing_details.show_title <> invalid and program.airing_details.show_title <> ""
            programNode.title = program.airing_details.show_title
        else
            programNode.title = "---"
        end if
        'Temporada y episodio
        if program.season_number <> invalid and program.episode_number <> invalid
            programNode.description = "S" + program.season_number.ToStr() + " E" + program.episode_number.ToStr()
        end if

        programNode.playStart = playStart

        programNode.playDuration = program.airing_details.duration

        programNodes.children.Push(programNode)

        playstart += programNode.playDuration
    end for
    'Actualiza el nodo de fila con todos los programas del canal como hijo
    'Para que se desplieguen en la vista 
    m.top.content.Update(programNodes)
end sub
