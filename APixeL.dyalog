:Namespace APixeL

ROOT ← 'http://r/'        ⋄ EVENT ← 'Event' 'HTTPRequest' 'Handler'
SIZE ← 'Size' (1920 1080) ⋄ COORD ← 'Coord' 'ScaledPixel'
URL  ← 'URL' (ROOT,'app') ⋄ INT   ← 'InterceptedURLs' (1 2⍴(ROOT,'*') 1)

'hr' ⎕WC'HTMLRenderer' INT URL EVENT SIZE COORD
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
    page  ← (≢ROOT)↓url

    found ← 200 'OK' (Css Js #.route⍎page)
    lost  ← 404 'Not Found' '<h2>Page not found!</h2>'

    (sc st data) ← found⊣⍣(2∊#.route.⎕NC page)⊢lost

    obj evt op 1 sc st 'text/html' url hdr data
}

Post ← {
    Canvas ← {
        (obj evt op int sc st mime url hdr data meth) ← ⍺
        (h w) ← 32⌊⍵
        table ← 'tbody' Tag ∊h/⊂'<tr>' (w/⊂'<td></td>') '</tr>'
        exec  ← 'document.getElementById("canvas").innerHTML ="',table,'";'
        exec ,← 'cells = document.getElementsByTagName("td");'
        exec ,← 'for (i = 0; i < cells.length; i++) {cells[i].addEventListener("click", fillSquare)}'

        _ ← hr.ExecuteJavaScript exec
        obj evt op 1 200 'OK' mime url hdr ⍬
    }

    Menu   ← {
        (obj evt op int sc st mime url hdr data meth) ← ⍺
        content ← Read 'menu/',⍵,'.html'
        _ ← hr.ExecuteJavaScript 'document.getElementById("menu").innerHTML =`',content,'`'
        obj evt op 1 200 'OK' mime url hdr ⍬
    }

    (obj evt op int sc st mime url hdr data meth) ← ⍵
    (expr fn arg) ← 0 ⎕JSON data
    'evaluate'≡expr:⍵ (⍎fn) arg
}

Handler ← {
    ⍺   ← 11↑⍵
    ⍝ ⎕ ← ⍺
    (obj evt op int sc st mime url hdr data meth) ← ⍺

    meth≡'GET' :Get  ⍺
    meth≡'POST':Post ⍺
}

:EndNamespace
