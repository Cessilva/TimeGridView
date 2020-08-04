function init()
    m.files = createObject("roFileSystem")
    m.files.Copyfile( "pkg:/images/logo3.png" , "cachefs:/logo3.png" ) 
    print m.files.exists("cachefs:/logo3.png")
end function