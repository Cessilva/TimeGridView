' ********** Copyright 2019 Roku Corp.  All Rights Reserved. ********** 
 'setting top interfaces
Sub Init()
    m.Title             = m.top.findNode("Title")
    m.Description       = m.top.findNode("Description")
    m.ReleaseDate       = m.top.findNode("ReleaseDate")
    m.Poster            = m.top.findNode("Poster")
    m.rectanglePrincipal= m.top.findNode("rectanglePrincipal")
    m.rectangleDescription= m.top.findNode("rectanglePrincipal")
    m.rectangleDescription.translation=[m.Poster.width+20,0]
End Sub
Sub OnContentChanged()
    item = m.top.content

    m.Title.text=item.Title
    m.Description.text=item.Description
    m.ReleaseDate.text=item.ReleaseDate+"  "+item.Rating+"  "+item.ShortDescriptionLine1
    m.Poster.uri=item.HDPosterUrl
End Sub
