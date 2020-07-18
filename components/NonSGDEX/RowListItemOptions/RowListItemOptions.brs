sub init()
    m.buttonText = m.top.findNode("buttonText")
    m.buttonText.font.size="24"
    m.buttonIcon = m.top.findNode("buttonIcon")
    m.mainRectangle = m.top.findNode("mainRectangle")
    m.frame = m.top.findNode("frame")
    m.bg = m.top.findNode("bg")
    centery = (m.frame.height-m.buttonIcon.height) / 2
    centerx = (m.frame.width-m.buttonIcon.width) / 2
    m.buttonIcon.translation = [centerx, centery-30]
end sub

sub onWidthChange()
  width = m.top.width
  m.buttonText.width= width
  m.mainRectangle.width=width
  m.frame.width=width
  m.bg.width=width-6
end sub
sub onHeightChange()
  height = m.top.height
  m.buttonText.height= height
  m.mainRectangle.height=height
  m.frame.height=height
  m.bg.height=height-6
end sub

sub showcontent()
  itemcontent = m.top.itemContent
  m.buttonIcon.uri = itemcontent.SDPosterUrl
  m.buttonText.text= itemcontent.title
end sub

sub onFocusChange()
    ?"onFocusChangeBotonLetra"
    if m.top.itemHasFocus or m.top.itemFocused then
        m.frame.color = "#0096d2"
        m.bg.color="#0096d2"
    else
        m.frame.color = "#3c3c3c"
        m.bg.color="#3c3c3c"
    end if
end sub

sub onColorChange()
m.frame.color = "#0096d2"
m.bg.color="#0096d2"
m.buttonText.color="ffffff"
end sub 