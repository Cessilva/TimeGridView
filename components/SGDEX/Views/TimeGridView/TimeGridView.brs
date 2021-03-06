' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

function Init()
'Se inicializa los nodos de vista  del TimeGridView: details y el poster que es
' la descripcion Aqui se inicializa m.view como el CustomTimeGrid 
    InitTimeGridViewNodes()
'FUNCION INICIAR OBTENCION DE VALORES DEL CONTENIDO de ContentManagerUtils.brs
    InitContentGetterValues()
    m.MAX_RADIUS = 45
    m.debug = false
    m.Handler_ConfigField = "HandlerConfigTimeGrid"
    m.SectionKeyField = "CM_row_ID_Index"
    'Se activa solo si se cambia de fila, en la misma no hace nada
    m.top.ObserveField("focusedChild", "OnFocusedChild")
    'Asigna el contenido con el manejador
    m.top.ObserveField("content", "OnContentChange")
    'Restablece el foco para la hora actual o el primer elemento 
    m.view.observeField("content", "onTimeGridViewContentChange")
    'Cambia el contenido del porster que es la descripcion con los valores
    'del canal y el programa
    m.top.ObserveField("posterShape", "OnPosterShapeChange")
    m.top.posterShape = "4x3"
    ' Establece los campos para el CustomTimeGrid 
    m.view.setFields({
        'Fondo del recorrido para ver el avanze opaco
        showPastTimeScreen: true
        channelInfoComponentName: "TimeGridChannelItemComponent"
    })

    
    'el CustomTimeGrid tiene varios fields:
    'canal y programa focused
    'Para que se reinicie el conteo de tiempo del borde izquierdo
    'si se recorre en el canal 
    'Programa seleccionado
    m.view.observeField("channelFocused", "channelFocused")
    m.view.observeField("programFocused", "programFocused")
    m.view.observeField("leftEdgeTargetTime", "onLeftEdgeTimeChanged")
    m.view.observeField("isScrolling", "onLeftEdgeTimeChanged")
    m.view.observeField("programSelected", "OnProgramSelected")
    'Crea un timer
    m.lazyLoadingTimer = CreateObject("roSGNode", "Timer")
    m.lazyLoadingTimer.repeat = false
    m.lazyLoadingTimer.duration = 3
    ' Cuando se active el timer empieza a cargar el contenido
    m.lazyLoadingTimer.observeField("fire", "StartContentLoading")

    currentTime =  CreateObject("roDateTime") ' roDateTime is initialized
    ' to the current time
    t = currentTime.AsSeconds()
    t = t - (t mod 1800) 
    'RDE-2665: TimeGrid funciona mejor cuando contentStartTime se establece en una marca de 30 m
    m.view.contentStartTime = t
    'AQUI SE CAMBIA EL ASPECTO DEL TIMEGRID 
    '(TALVEZ LO PODRIA PONER EN EL COMPONENTE CustomTimeGrid)
    m.view.translation=[0,10]
    'Letras de la barra
    m.view.timeLabelColor="#c91616"
    'Color del tiempo pasado
    m.view.pastTimeScreenBlendColor="#c91616"
    'Color de linea de tiempo
    m.view.nowBarBlendColor="#7c7c7c"
    'La barrita de alado va a tomar el tiempo corriente en segundos 
    m.view.leftEdgeTargetTime = currentTime.AsSeconds()
    'Si el canal no tiene texto 
    m.view.channelNoDataText = "Loading..."
    m.view.loadingDataText = "Loading..."
    ' Permite que la región de datos del programa de la cuadrícula se 
    ' reemplace automáticamente con el mensaje de carga especificado 
    ' en el campo loadingDataText cada vez que el campo de contenido 
    ' no se ha establecido o el usuario se desplaza a un momento en 
    ' el que el contenido aún no se ha cargado.
    m.view.automaticLoadingDataFeedback = false
    'Numero de filas visibles
    m.view.numRows = 7
    ' Inserta un programa con la etiqueta "No hay datos disponibles" si hay 
    ' una brecha entre la hora de inicio del programa y la hora de finalización
    ' del programa anterior
    m.view.fillProgramGaps = true

    ' View constants:Ayudan a alinear el timegrid
    'Este no se que hace
    m.detailsTimeGridSpacing = 25
    'Bandera
    m.timeGridWasMoved = false
end function

sub InitTimeGridViewNodes()
    m.details = m.top.viewContentGroup.CreateChild("ItemDetailsView")
    m.details.Update({
        id: "details"
        translation: [105,0]
        maxWidth: 666
    })
    'Esta es la descripcion del canal
    m.poster = m.top.viewContentGroup.CreateChild("StyledPoster")
    m.poster.Update({
        id: "poster"
        translation: [200,400]
        maxWidth: 357
        maxHeight: 201
    })
    'Declaracion de m.view que es un componente CustomTimeGrid
    m.view = m.top.findNode("timeGrid")
    m.view.Reparent(m.top.viewContentGroup, false)
    'Mueve de padre al nodo, se va con viewContentGroup
    'reparent(newParent as roSGNode, adjustTransform as Boolean) as Boolean
    'Moves the subject node to another parent node.
end sub


Sub onLeftEdgeTimeChanged()
    RestartLazyLoadingTimer()
    if not m.view.isScrolling
        StartContentLoading(true)
    end if
End Sub

sub OnFocusedChild()
    if m.top.isInFocusChain() and not m.view.hasFocus() then
        m.view.setFocus(true)
    end if
end sub
'Actualiza el contenido 
sub OnContentChange()
    if m.top.content <> invalid
        if not m.top.content.IsSameNode(m.view.content) and not m.top.content.IsSameNode(m.content) then
            m.content = m.top.content
            PopulateLoadingFlags(m.top.content)
            if m.top.content[m.Handler_ConfigField] <> invalid and m.top.content.GetChildCount() = 0
                config = m.top.content[m.Handler_ConfigField]
                callback = {
                    config: config
                    content: m.top.content
                    onReceive: sub(data)
                        OnRootContentLoaded()
                    end sub

                    onError: sub(data)
                        config = m.config
                        gthis = GetGlobalAA()
                        if m.content[gthis.Handler_ConfigField] <> invalid then
                            config = m.content[gthis.Handler_ConfigField]
                        end if

                        GetContentData(m, config, m.content)
                    end sub
                }
                GetContentData(callback, config, m.top.content)
            else if m.top.content.GetChildCount() > 0
                OnRootContentLoaded()
            end if
        end if
    end if
end sub


' OnProgramSelected triggered when timeGrid.programSelected updated on user
' selection. Updating rowItemSelected interface to have similar behavior
' with GridView
sub OnProgramSelected(event as Object)
    timeGrid = event.GetRoSGNode()
    m.top.rowItemSelected = [timeGrid.channelSelected, timeGrid.programSelected]    
    ' content=timeGrid.content
    ' timeGridScreen=ShowDetailsScreen(content)
end sub

function channelFocused(event as Object)
    RestartLazyLoadingTimer()
    if m.view <> invalid
        ChannelProgramFocused(m.view.channelFocused, m.view.programFocused)
    end if
end function

function programFocused(event as Object)
    RestartLazyLoadingTimer()
    if m.view <> invalid
        ChannelProgramFocused(m.view.channelFocused, m.view.programFocused)
    end if
end function

' ChannelProgramFocused is invoked when either channelFocused or programFocused was changed
' Used for loading content when user navigates vertically
' And updating the item details panel
sub ChannelProgramFocused(currentRowIndex as Integer, currentItemIndex as Integer)
    row = invalid
    if m.view.content <> invalid then
        row = m.view.content.GetChild(currentRowIndex)
    end if
    if row <> invalid
        focusIndexToSet = currentItemIndex
        if currentItemIndex < 0 then currentItemIndex = 0
        UpdateItemDetails(currentRowIndex, currentItemIndex)

        if m.previousFocusedRow <> currentRowIndex
            StartContentLoading(true)
        end if
    end if
    m.previousFocusedRow = currentRowIndex
    m.previousFocusedItemIndex = currentItemIndex
end sub

sub UpdateItemDetails(channelIndex, programIndex)
    content = m.view.content
    if content = invalid then return
    channel = content.GetChild(channelIndex)
    if channel = invalid then return
    program = channel.GetChild(programIndex)

    shouldClearMeta = false
    if program = invalid then
        shouldClearMeta = true
    else
        diff = m.view.leftEdgeTargetTime - program.PLAYSTART

        bIsInPast = diff > 0 and diff - program.playduration > 0
        bIsInFuture = diff + m.view.duration < 0

        if bIsInPast then ' need to account duration that item might be partly visible
            ' focused item is in past
            shouldClearMeta = true
        else if bIsInFuture then ' item might be partly visible in future
            ' focused item is in future
            shouldClearMeta = true
        end if

        if m.debug then
            ?"---------------"
            ? " diff "diff " duration "m.view.duration
            ? "diff is past "bIsInPast
            ?" diff is future "bIsInFuture
            ?"---------------"
        end if
    end if

    if shouldClearMeta
        program = CreateObject("roSGNode", "ContentNode")
        ' don't set any title here
        ' in some cases content wouldn't even be loaded in future,
        ' as there might be no config for channel
        program.title = ""
    end if

    m.details.content = program
    m.poster.uri = program.hdposterurl
    if m.poster.uri.Len() > 0 then
        m.details.translation = [m.poster.translation[0] + m.poster.width + 15, m.poster.translation[1]]
        AlignTimeGrid()
    else
        m.details.translation = m.poster.translation
    end if
end sub

sub AlignTimeGrid()
    if not m.timeGridWasMoved
        posterHeight = m.poster.maxHeight
        posterBottomY = m.poster.boundingRect().y + posterHeight

        ' calculate timeBarHeight because translation of TimeGrid component
        ' somehow is not calculated from the top of TimeBar
        timeBarHeight = m.view.timeBarHeight
        if timeBarHeight = 0 then timeBarHeight = 50

        timeGridY = posterBottomY + timeBarHeight + m.detailsTimeGridSpacing
        m.view.translation = [m.view.translation[0], timeGridY]

        m.timeGridWasMoved = true
    end if
end sub

function OnPosterShapeChange() as Object
    m.poster.shape = m.top.posterShape
    if m.top.content <> invalid then
        ChannelProgramFocused(m.view.channelFocused, m.view.programFocused)
    end if
end function

Sub RestartLazyLoadingTimer()
    m.lazyLoadingTimer.control = "stop"
    m.lazyLoadingTimer.control = "start"
End Sub

Sub StartContentLoading(populateOnlyVisibleChannels = false as Boolean, leftEdgeTargetTimePriority = true as Boolean)
    channelIndex = m.view.channelFocused
    programIndex = m.view.programFocused
    content = m.view.content
    if content = invalid then return
    channel = content.GetChild(channelIndex)
    if channel = invalid then return 'invalid focus event'
    program = channel.GetChild(programIndex)
    if program = invalid OR leftEdgeTargetTimePriority then
        startTime = m.view.leftEdgeTargetTime
    else
        startTime = program.playstart
    end if

    visibleChannelsToLoad = m.view.numRows - 1
    outOfScreenChannelsToLoad = m.view.numRows
    outOfScreenCacheTimeToLoad = 3600 * 3
    if populateOnlyVisibleChannels then outOfScreenChannelsToLoad = 0
    startChannelIndex = channelIndex - outOfScreenChannelsToLoad
    totalChannelsToLoad = visibleChannelsToLoad + outOfScreenChannelsToLoad*2
    channelIndexIterator = NewCycleNodeChildrenIterator(content, startChannelIndex, totalChannelsToLoad)

    if IsInsertionMode(channel[m.Handler_ConfigField]) then
        CACHE_TIME = channel[m.Handler_ConfigField].pageSize * 3600
        if not populateOnlyVisibleChannels then
            startTime -= outOfScreenCacheTimeToLoad
            if startTime < m.view.contentStartTime then
                startTime = m.view.contentStartTime
            end if
            CACHE_TIME += outOfScreenCacheTimeToLoad * 2
        else
            startTime -= 3600
        end if
    else
        CACHE_TIME = 0
        startTime = m.view.contentStartTime
    end if

    channelsProcessed = 0

    while true
        i = channelIndexIterator.GetIndex()
        if not isPageAlreadyInQueue(i, 0) then
            channelNode = content.GetChild(i)
            pageToLoad = getPageToLoadInRange(channelNode, startTime, startTime + CACHE_TIME)
            if pageToLoad <> invalid then
                LoadInsertionContent(pageToLoad, channelNode)
            end if
        end if
        channelsProcessed++
        if not channelIndexIterator.IsNextAvailable() then exit while
        channelIndexIterator.Next()
    end while

    RestartLazyLoadingTimer()
End Sub

Function getPageToLoadInRange(channelNode, startTime, endTime)
    if not IsInsertionMode(channelNode[m.Handler_ConfigField]) then
        ' will be executed only once
        if channelNode.getChildCount() > 0 then return invalid

        ' request only start without limitation of end
        return {
            pageNum: startTime
            index: 0
            endTime: 0
        }
    end if

    insertPosition = 0

    for i = 0 to channelNode.GetChildCount() - 1
        insertPosition = i
        programNode = channelNode.GetChild(i)

        if programNode.PlayStart >= endTime then
            ' we should insert content before this item
            ' fixes issue with inserting content when scrolling backward
            ' and there is no content on very beginning of the row
            insertPosition -= 1
            exit for
        end if

        if programNode.PlayStart <= startTime AND (programNode.PlayStart + programNode.PlayDuration) > startTime then
            startTime = programNode.PlayStart + programNode.playduration
        end if

        if programNode.PlayStart > startTime then
            ' Limit end time by next program start time - 1 seconds in order to avoid duplicates'
            endTime = programNode.PlayStart - 1
            insertPosition -= 1
            exit for
        end if
    end for

    if startTime >= endTime then return invalid

    return {
        pageNum: startTime
        index: insertPosition
        endTime: endTime
    }
End Function

Sub onTimeGridViewContentChange()
    ' Esta lógica restablecerá el foco a la hora actual o al primer elemento
    ' válido si no hay contenido para la hora actual
    if m._isContentFocusResetDone = true then return
    content = m.view.content
    if content = invalid then return

    channel = content.getChild(0)
    if channel = invalid OR channel.getChildCount() = 0 then return

    isNowProgramAvailable = false
    currentTime = m.view.leftEdgeTargetTime
    for each program in channel.GetChildren(-1, 0)
        if program.PlayStart <= currentTime AND program.PlayStart + program.PlayDuration >= currentTime then
            isNowProgramAvailable = true
            exit for
        end if
    end for

    if not isNowProgramAvailable then
        ' focus to begin on content
        m.view.jumpToProgram = 0
        m.view.leftEdgeTargetTime = channel.GetChild(0).PlayStart
    end if

    m._isContentFocusResetDone = true
End Sub

Function AlignTimeToHours(timestamp as Integer) as Integer
    return timestamp - timestamp MOD 3600
End Function

Function NewCycleNodeChildrenIterator(node, startIndex, count) as Object
    maxIndex = node.GetChildCount() - 1

    while startIndex < 0
        startIndex = maxIndex + startIndex
    end while

    if startIndex > maxIndex then
        startIndex = maxIndex
    end if

    return {
        _node: node

        _max_index: maxIndex
        _index: startIndex

        _max_count: count
        _current_count: 0

        IsNextAvailable: function() as Boolean
            return m._current_count < m._max_count
        end function

        Next : function() as Integer
            if m.IsNextAvailable() then
                if m._index >= m._max_index then
                    m._index = 0
                else if m._index < m._max_index then
                    m._index++
                end if
                m._current_count++
            end if
            return m._index
        end function

        GetIndex: function() as integer
            return m._index
        end function
    }
End Function
