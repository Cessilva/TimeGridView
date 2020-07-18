
Function Init()
    ? "[ScreenOptions] Init" 
    'Declaracion de elementos
    m.myRowListButtons=m.top.findNode("myRowListButtons")    
    m.rectanglePrincipal=m.top.findNode("rectanglePrincipal")
    m.myDescription=m.top.findNode("myDescription")
    m.myRowListCalidades=m.top.findNode("myRowListCalidades")
    m.myRowListIdiomas=m.top.findNode("myRowListIdiomas")

    ' m.myRowListCalidades=createObject("roSGNode","RowListButtons")
    ' m.myRowListIdiomas=createObject("roSGNode","RowListButtons")
    
    'Visibles iniciales
    m.myDescription.visible=true
    m.myRowListCalidades.visible=false
    m.myRowListIdiomas.visible=false
    ' Contenido de rowlistButtons
    botones=[
      {Title:"Info"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Calidad"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Idioma"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      ]
    listaBotones= [
        {
            Title: "Lista de botones de eleccion"
            ContentList: botones
        }
    ]
    contentBotones = parseContent(listaBotones)

    'Contenido de la descripcion
    ContentNode= createObject("RoSGNode","ContentNode")
    ContentNode.Title="Avengers End-Game"
    ContentNode.ContentType=1
    ContentNode.HDPosterUrl="http://s2.content.video.llnw.net/lovs/images-prod/59021fabe3b645968e382ac726cd6c7b/media/decbe34b64ea4ca281dc09997d0f23fd/j5_.540x304.jpeg"
    ContentNode.ReleaseDate="3/31/2009"
    ContentNode.Rating="PG-13"
    ContentNode.ShortDescriptionLine1="Accion y Aventura"
    ContentNode.Description="The transformation accumulation allows node classes to be developed without regard to their absolute pixel coordinates. Instead, each node can be ha"
    m.top.nodoContenido=ContentNode
    ' Contenido de rowlistCalidades
    calidades=[
      {Title:"Alta"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Media"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Baja"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      ]
    listaCalidades= [
        {
            Title: "Lista de botones de calidad"
            ContentList:calidades
        }
    ]
    contentCalidades = parseContent(listaCalidades)

     ' Contenido de rowlistIdiomas
    idiomas=[
      {Title:"Español"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Ingles"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Frances"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      ]
    subtitulos=[
      {Title:"Desactivado"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Español"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Ingles"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      {Title:"Frances"
      SDPosterUrl:"pkg:/images/transparente.png"
      }
      ]
    listaIdiomas= [
        {
            Title: "Idiomas"
            ContentList:idiomas
        }
        {
            Title: "Subtitulos"
            ContentList:subtitulos
        }
    ]
    contentIdiomas = parseContent(listaIdiomas)

    'Asignaciones de contenido
    m.myRowListButtons.content=contentBotones
    m.myRowListButtons.elements=3

    m.myDescription.Content=ContentNode

    m.myRowListCalidades.content=contentCalidades
    m.myRowListCalidades.elements=3

    m.myRowListIdiomas.content=contentIdiomas
    m.myRowListIdiomas.numFilas=2
    m.myRowListIdiomas.mostrarLabel=true
    m.myRowListIdiomas.elements=4
    'Medidas
    medida= m.rectanglePrincipal.boundingRect()
    m.rectanglePrincipal.height=medida.height

    m.myRowListButtons.fatherWidth= m.rectanglePrincipal.width
    m.myRowListButtons.heightComponent=20

    medidaRowListButtons=m.myRowListButtons.boundingRect()
    medidamyDescription=m.myDescription.boundingRect()
    m.myDescription.translation=[(medida.width-medidamyDescription.width)/2,medidaRowListButtons.height]
    
    m.myRowListCalidades.fatherWidth= m.rectanglePrincipal.width
    m.myRowListCalidades.heightComponent=medidaRowListButtons.height

    m.myRowListIdiomas.fatherWidth= m.rectanglePrincipal.width
    m.myRowListIdiomas.heightComponent=medidaRowListButtons.height

    'Observables
    m.myRowListButtons.observeField("letra", "cambioContenido")
End Function

sub asignaFocus()
if m.top.hasFocus= true then
m.myRowListButtons.setFocus(true)
end if
end sub


sub cambioContenido()
if m.myRowListButtons.letra="Info" then 
    m.myDescription.visible=true
    m.myRowListCalidades.visible=false
    m.myRowListIdiomas.visible=false
    cambiaAlto(m.myRowListButtons.letra)
else if m.myRowListButtons.letra="Calidad" then
    m.myDescription.visible=false
    m.myRowListCalidades.visible=true
    m.myRowListIdiomas.visible=false
    cambiaAlto(m.myRowListButtons.letra)
else if m.myRowListButtons.letra="Idioma" then
    m.myDescription.visible=false
    m.myRowListCalidades.visible=false
    m.myRowListIdiomas.visible=true
    cambiaAlto(m.myRowListButtons.letra)
end if 
end sub

sub cambiaAlto(string)
medidaRowListButtons=m.myRowListButtons.boundingRect()
medidamyDescription= m.myDescription.boundingRect()
medidamyRowListCalidades= m.myRowListCalidades.boundingRect()
medidamyRowListIdiomas= m.myRowListIdiomas.boundingRect()
if string="Info" then
m.rectanglePrincipal.height=medidaRowListButtons.height+medidamyDescription.height
else if string="Calidad" then
m.rectanglePrincipal.height=medidaRowListButtons.height+medidamyRowListCalidades.height
else if string="Idioma" then
m.rectanglePrincipal.height=medidaRowListButtons.height+medidamyRowListIdiomas.height
end if
end sub

function parseContent(list As Object)
    ContentNode_object = createObject("RoSGNode","ContentNode")
    for each objeto in list
        ContentNode_object_child = createObject("RoSGNode","ContentNode")
        ContentNode_object_child.Title=objeto.Title
        for each arreglo in objeto.ContentList
                elemento=createObject("RoSGNode","ContentNode")
                elemento.setFields(arreglo)
                ContentNode_object_child.appendChild(elemento)
        end for
        ContentNode_object.appendChild(ContentNode_object_child)
    end for
    return ContentNode_object
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
handled = false
if (not press) then
    if (key = "down" ) then
        if m.myRowListButtons.letra="Calidad" then
            m.myRowListCalidades.setFocus(true)
        else if m.myRowListButtons.letra="Idioma" then
            m.myRowListIdiomas.setFocus(true)
        end if
    else  if (key = "up" ) then
        m.myRowListButtons.setFocus(true)
    else  if (key = "OK" ) then
        if m.myRowListIdiomas.isInFocusChain() or m.myRowListCalidades.isInFocusChain() then
        m.top.salida=true
        end if 
    end if
end if
return handled
end function