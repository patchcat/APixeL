:Namespace APixeL

Root ← 'http://r/'       ⋄ Event     ← 'Event' 'HTTPRequest' 'Handler'
Size ← 'Size'(2⍴1000)    ⋄ Coord     ← 'Coord' 'ScaledPixel'
Url  ← 'URL'(Root,'app') ⋄ Intercept ← 'InterceptedURLs' (1 2⍴(Root,'*') 1)

'hr' ⎕WC'HTMLRenderer' Intercept Url Event Size Coord
hr.ShowDevTools 1

L     ← ⊃⊢⌿
F     ← ⊃⊣⌿
In    ← ∊⊣@('`'∘=)
Tag   ← {∊'<'⍺'>'⍵'</'⍺'>'}
Read  ← ⊃∘⎕NGET
Brush ← 0

#.route     ← ⎕NS''
#.route.app ← Read 'app.html'

Js ← {
    names ← '\w*.js\b' ⎕S {⍵.Match} ⍵
    tmp   ← ∊'\s*'∘,¨'<script src="`"></script>'
    ⊃{((⍵ In tmp)⎕R('script' Tag Read ⊃⍵))⍺}/⍵ names
}

Css ← {
    names ← '\w*.css\b' ⎕S {⍵.Match} ⍵
    tmp   ← ∊'\s*'∘,¨'<link rel="stylesheet" href="`"/>'
    ⊃{((⍵ In tmp)⎕R('style' Tag Read ⊃⍵))⍺}/⍵ names
}

Get ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍵
    page  ← (≢Root)↓url

    found ← 200 'OK' (Css Js #.route⍎page)
    lost  ← 404 'Not Found' '<h2>Page not found!</h2>'

    (sc st data) ← found⊣⍣(2∊#.route.⎕NC page)⊢lost

    obj evt op 1 sc st 'text/html' url hdr data
}

Post ← {
    Canvas ← {
        table ← 'tbody' Tag ∊(100⌊⍺)/⊂'<tr>' ((100⌊⍵)/⊂'<td></td>') '</tr>'
        hr.ExecuteJavaScript 'document.getElementById("canvas").innerHTML ="',table,'"'
    }

    Menu   ← {
        content ← Read 'menu/',⍵,'.html'
        hr.ExecuteJavaScript 'document.getElementById("menu").innerHTML =`',content,'`'
    }

    (obj evt op int sc st mime url hdr data meth) ← ⍵
    r ← 0 ⎕JSON data
    'evaluate'≡F r:⍎L r
}

Handler ← {
    ⍺   ← 11↑⍵
    ⍝ ⎕ ← ⍺
    (obj evt op int sc st mime url hdr data meth) ← ⍺

    meth≡'GET' :Get  ⍺
    meth≡'POST':Post ⍺
}

:EndNamespace
