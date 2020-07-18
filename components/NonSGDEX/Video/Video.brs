sub init()
  m.top.setFocus(true)
  setVideo()
end sub

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"
  videoContent.title = "Test Video"
  videoContent.streamformat = "hls"

  m.video = m.top.findNode("musicvideos")
  m.video.content = videoContent
  m.video.control = "play"
end function