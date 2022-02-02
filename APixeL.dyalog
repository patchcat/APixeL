:Namespace APixeL

root ← 'http://r/'        ⋄ event ← 'Event' 'HTTPRequest' 'Handler'
size ← 'Size' (1920 1080) ⋄ coord ← 'Coord' 'ScaledPixel'
url  ← 'URL' (root,'app') ⋄ int   ← 'InterceptedURLs' (1 2⍴(root,'*') 1)

'hr' ⎕WC'HTMLRenderer' int url event size coord

In    ← ∊⊣@('`'∘=)
Tag   ← {∊'<'⍺'>'⍵'</'⍺'>'}
Read  ← ⊃∘⎕NGET
Esc   ← {⊃(↑⍪'\'⍪↓)/(1-⍨⍸∨⌿⍺∘.=⍵),⊂⍵}

#.route     ← ⎕NS''
#.route.app ← Read 'app.html'

Js ← {
    name ← '\w*.js\b' ⎕S '&'⊢⍵
    tmp  ← name In ∊'\s*'∘,¨'<script src="`" charset="utf-8"></script>'
    tmp⎕R('%\' Esc 'script' Tag Read name)⊢⍵
}

Css ← {
    name ← '\w*.css\b' ⎕S '&'⊢⍵
    tmp  ← name In ∊'\s*'∘,¨'<link rel="stylesheet" href="`"/>'
    tmp⎕R('%\' Esc 'style' Tag Read name)⊢⍵
}

Get ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍵
    page  ← (≢root)↓url

    found ← 200 'OK' (Css Js #.route⍎page)
    lost  ← 404 'Not Found' '<h2>Page not found!</h2>'

    (sc st data) ← found⊣⍣(2∊#.route.⎕NC page)⊢lost

    obj evt op 1 sc st 'text/html' url hdr data
}

WriteTable ← {
    exec  ← 'document.getElementById("canvas").innerHTML ="',⍵,'";'
    exec ,← 'cells = document.getElementsByTagName("td");'
    exec ,← 'for (i = 0; i < cells.length; i++) {cells[i].addEventListener("click", fillSquare)}'
    hr.ExecuteJavaScript exec
}

Canvas ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍺
    (h w) ← 32⌊⍵
    table ← 'tbody' Tag ∊h/⊂'<tr>' (w/⊂'<td style=''background-color: rgb(255, 255, 255);''></td>') '</tr>'
    _ ← WriteTable table

    obj evt op 1 200 'OK' mime url hdr ⍬
}

Menu   ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍺
    content ← Read 'menu/',⍵,'.html'
    _ ← hr.ExecuteJavaScript 'document.getElementById("menu").innerHTML =`',content,'`'

    obj evt op 1 200 'OK' mime url hdr ⍬
}

ToTable  ← {
    ToRgb ← {∊'rgb('(','(1↓∘,,∘⍕⍤0)⍵⊤⍨3/256)')'}
    cells ← ({⊂'<td style=''background-color: `;''></td>' In⍨⊂ToRgb⍵}⍤0)⍵
    (∊'tbody' Tag {'<tr>'⍵'</tr>'}⍤1)cells
}

ToMatrix ← {
    FromRgb ← {256⊥⍤1⎕CSV(~∘'rgb()'¨⍵)⍬ 2}
    ⍺⍴FromRgb ⍵
}

RunAPL  ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍺

    ⍳11::{
        err ← ⎕DMX.EM,': ',⎕DMX.Message
        _ ← hr.ExecuteJavaScript 'document.getElementById("stacktrace").innerHTML =`',err,'`'
        obj evt op 1 200 'OK' mime url hdr ⍬
    } ⍬
        
    (fn data shape) ← ⍵
    _ ← WriteTable ToTable (⍎ 'UTF-8' ⎕UCS fn) shape ToMatrix data
    _ ← hr.ExecuteJavaScript 'document.getElementById("stacktrace").innerHTML = ``'
    obj evt op 1 200 'OK' mime url hdr ⍬
}

Save    ← {
    (file data shape) ← ⍵
     
    file 1 ⎕NPUT⍨⊂⍕¨↓shape ToMatrix data
} 

Post ← {
    (obj evt op int sc st mime url hdr data meth) ← ⍵

    (expr fn arg) ← 0 ⎕JSON data
    'evaluate'≡expr:⍵ (⍎fn) arg
}

Handler ← {
    ⍺   ← 11↑⍵
    (obj evt op int sc st mime url hdr data meth) ← ⍺

    meth≡'GET' :Get  ⍺
    meth≡'POST':Post ⍺
}

:EndNamespace
