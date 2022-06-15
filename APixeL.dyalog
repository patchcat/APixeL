:NameSpace APixeL

    F    ← ⊃,/
    In   ←  F ⊣@('`'∘=)
    Tag  ← {F '<' ⍺ '>' (F ⍵) '</' ⍺ '>'}
    Read ← ⊃∘⎕NGET
    Esc  ← {⊃(↑⍪'\'⍪↓)/(1-⍨⍸∨⌿⍺∘.=⍵),⊂⍵}

      Js←{
          name←('\w*.js\b'⎕S'&')⍵
          tmp←name In F'\s*'∘,¨'<script src="`" charset="utf-8"></script>'
          (tmp ⎕R('%\'Esc'script'Tag Read name))⍵
      }

      Css←{
          name←('\w*.css\b'⎕S'&')⍵
          tmp←name In F'\s*'∘,¨'<link rel="stylesheet" href="`"/>'
          tmp(⎕R('%\'Esc'style'Tag Read name))⍵
      }

      APL←{
          ⍳11::f.app.ExecuteJavaScript'document.getElementById("stacktrace").innerHTML =`',(⎕DMX.(Message{⍵,⍺,⍨': '/⍨×≢⍺}⎕EM EN)),'`'
     
          (fn data shape)←⍵
          ∆Table ⍙Table((⍎)'UTF-8'⎕UCS fn)shape ⍙Canvas data
      }

    ⍙Rgb ← {256⊥⍤1 ⎕CSV(~∘'rgb()'¨⍵)⍬ 2}
    ∆Rgb ← {F 'rgb('(','(1↓∘,,∘⍕⍤0)⍵⊤⍨3/256)')'}

      ⍙Table←{
          cells←({⊂'<td style=''background-color: `;''></td>'In⍨⊂∆Rgb ⍵}⍤0)⍵
          ('tbody'Tag∘,'tr'∘Tag⍤1)cells
      }

      ∆Table←{
          exec←'document.getElementById("canvas").innerHTML ="',⍵,'";'
          exec,←'cells = document.getElementsByTagName("td");'
          exec,←'for (i = 0; i < cells.length; i++) {cells[i].addEventListener("click", fillSquare)}'
          f.app.ExecuteJavaScript exec
      }

    ⍙Canvas ← ⍴∘⍙Rgb

      ∆Canvas←{
          (h w)←32⌊⍵
          ∆Table'tbody'Tag∊h/⊂'<tr>'(w/⊂'<td style=''background-color: rgb(255, 255, 255);''></td>')'</tr>'
      }

      Menu←{
          content←Read'menu/',⍵,'.html'
          f.app.ExecuteJavaScript'document.getElementById("menu").innerHTML =`',content,'`'
      }

      Handler←{
          (ref event id data fin type)←⍵
     
          (fn arg)←0 ⎕JSON data
          'Menu'≡fn:Menu arg
          'Canvas'≡fn:∆Canvas arg
          'APL'≡fn:APL arg
      }

    ∇ init;f
      'f'⎕WC'Form'
      f.(Posn Size)←(0 0)(100 100)
      'f.app'⎕WC'HTMLRenderer'('AsChild' 1)
      f.app.(Event Posn Size HTML)←('WebSocketReceive' 'Handler')(0 0)(100 100)(Css Js Read'app.html')
      ⎕DQ'f'
    ∇

:EndNameSpace