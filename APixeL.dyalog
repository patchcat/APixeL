:NameSpace APixeL

    F    ← ⊃,/
    In   ← F ⊣@('`'∘=) ⍝ Replace back-ticks in ⍵ with ⍺; 1 2 3 In '[`,`,`]' - > '[ 1 , 2 , 3 ]'
    Tag  ← F {'<' ⍺ '>' (F ⍵) '</' ⍺ '>'}
    Read ← ⊃∘⎕NGET
    Esc  ← {⊃(↑⍪'\'⍪↓)/(1-⍨⍸∨⌿⍺∘.=⍵),⊂⍵} ⍝ Escape characters of ⍺ in ⍵

      Js←{
          name←('\w*.js\b'⎕S'&')⍵
          tmp←name In F'\s*'∘,¨'<script src="`" charset="utf-8"></script>'
          (tmp ⎕R('%\'Esc'script'Tag Read name))⍵
      } ⍝ Replace <script src="X"></script> with X's content inline

      Css←{
          name←('\w*.css\b'⎕S'&')⍵
          tmp←name In F'\s*'∘,¨'<link rel="stylesheet" href="`"/>'
          tmp(⎕R('%\'Esc'style'Tag Read name))⍵
      } ⍝ Replace <script src="X"></script> with X's content inline

    ⍙Rgb ← {256⊥⍤1 ⎕CSV(~∘'rgb()'¨⍵)⍬ 2}          ⍝ rgb(x,y,z) -> 256⊥x y z; css colour attributes to integer matrix
    ∆Rgb ← {F 'rgb('(','(1↓∘,,∘⍕⍤0)⍵⊤⍨3/256)')'}  ⍝ I -> rgb(256 256 256⊤I); precisely ⍙Rgb⍣¯1

      APL←{
          ⍝ Trap and display user errors
          ⍳11::f.app.ExecuteJavaScript'document.getElementById("stacktrace").innerHTML =`',(⎕DMX.(Message{⍵,⍺,⍨': '/⍨×≢⍺}⎕EM EN)),'`'
     
          (fn data shape)←⍵
          w∆Table t∆Table((⍎)'UTF-8'⎕UCS fn)shape ⍴∘⍙Rgb data
      } ⍝ Apply fn to Canvas

      t∆Table←{
          cells←({⊂'<td style=''background-color: `;''></td>'In⍨⊂∆Rgb ⍵}⍤0)⍵
          ('tbody' Tag∘, 'tr'∘Tag⍤1)cells
      } ⍝ Transform integer matrix to html table

      w∆Table←{
          exec←'document.getElementById("canvas").innerHTML ="',⍵,'";'
          exec,←'cells = document.getElementsByTagName("td");'
          exec,←'for (i = 0; i < cells.length; i++) {cells[i].addEventListener("click", fillSquare)}'
          f.app.ExecuteJavaScript exec
      }  ⍝ Overwrite #canvas with tbody string

      Canvas←{
          (h w)←32⌊⍵
          w∆Table 'tbody'Tag∊h/⊂'<tr>'(w/⊂'<td style=''background-color: rgb(255, 255, 255);''></td>')'</tr>'
      } ⍝ #canvas table of size h×w - compromising of white cells. 

      Menu←{
          content←Read'menu/',⍵,'.html'
          f.app.ExecuteJavaScript'document.getElementById("menu").innerHTML =`',content,'`'
      } ⍝ Set menu item

      Handler←{
          (ref event id data fin type)←⍵
     
          (fn arg)←0 ⎕JSON data
          'Menu'   ≡ fn: Menu   arg
          'Canvas' ≡ fn: Canvas arg
          'APL'    ≡ fn: APL    arg
      }

    ∇ init;f
      'f'⎕WC'Form'
      f.(Posn Size)←(0 0)(100 100)
      'f.app'⎕WC'HTMLRenderer'('AsChild' 1)
      f.app.(Event Posn Size HTML)←('WebSocketReceive' 'Handler')(0 0)(100 100)(Css Js Read'app.html')
      ⎕DQ'f'
    ∇

:EndNameSpace