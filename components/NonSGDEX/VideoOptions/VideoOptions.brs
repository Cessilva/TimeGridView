sub init()
m.consulta=m.top.findNode("Consulta")
m.consulta.content="Presiona hacia abajo para salir"
m.consulta.heightConsulta="580"
m.botones=[
      {Title:"Grabar temporada"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Grabar episodio"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Ver desde inicio"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Bloquear canal"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Eliminar de favoritos"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Cambiar subtitulos"
      SDPosterUrl:"pkg:/images/cine.png"
      }
      {Title:"Ir a guía completa "
      SDPosterUrl:"pkg:/images/cine.png"
      }
      ]
    listaBotones= [
        {
            Title: "Avengers End-Game"
            ContentList: m.botones
        }
    ]
contentBotones = parseContent(listaBotones)
m.myRowListOptions=m.top.findNode("myRowListOptions")
m.myRowListOptions.elements=7
m.myRowListOptions.content=contentBotones
m.myRowListOptions.numFilas=1
m.myRowListOptions.mostrarLabel=true
m.myRowListOptions.nameComponent="RowListItemOptions"
m.myRowListOptions.itemSize=[[160,140]]
medidaRowListOptions=m.myRowListOptions.boundingRect()
m.myRowListOptions.heightComponent=medidaRowListOptions.height
print "Ancho de rowlistOptions"
print m.myRowListOptions.width
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

sub asignaFocus()
if m.top.hasFocus= true then
m.myRowListOptions.setFocus(true)
end if
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
handled = false
if (not press) then
    if (key = "OK" ) then
        if m.myRowListOptions.isInFocusChain()  then
        m.top.salida=true
        end if 
    end if
end if
return handled
end function

sub tituloCambia()
listaBotones= [
        {
            Title:m.top.titulo
            ContentList: m.botones
        }
    ]
contentBotones = parseContent(listaBotones)
m.myRowListOptions.content=contentBotones
end sub 