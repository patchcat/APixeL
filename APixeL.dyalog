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
      }

      Css←{
          name←('\w*.css\b'⎕S'&')⍵
          tmp←name In F'\s*'∘,¨'<link rel="stylesheet" href="`"/>'
          tmp(⎕R('%\'Esc'style'Tag Read name))⍵
      }

    ⍙Rgb ← {256⊥⍤1 ⎕CSV(~∘'rgb()'¨⍵)⍬ 2}      ⍝ rgb(x,y,z) -> 256⊥x y z; css colour attributes to integer matrix
    ∆Rgb ← {F 'rgb('(⍕1↓','(,,)⍪⍵⊤⍨3/256)')'} ⍝ I -> rgb(256 256 256⊤I); precisely ⍙Rgb⍣¯1

      t∆Table←{
          cells←{'<td style=''background-color: ',(∆Rgb ⍵),';''></td>'}¨⍵
          'tbody'Tag,('tr'∘Tag⍤1)cells
      }

      w∆Table←{
          exec←'document.getElementById("canvas").innerHTML ="',⍵,'";'
          exec,←'cells = document.querySelectorAll("td");'
          exec,←'cells.forEach(c => c.addEventListener("click", fillSquare))'
          f.ExecuteJavaScript exec
      }

      Menu←{
          content←Read'menu/',⍵,'.html'
          f.ExecuteJavaScript'document.getElementById("menu").innerHTML =`',content,'`'
      }
      
      Canvas←{
          (h w)←32⌊⍵
          w∆Table'tbody'Tag h⍴⊂'tr'Tag w⍴⊂'<td style=''background-color: rgb(255, 255, 255);''></td>'
      }
      
      APL←{
          ⍝ Trap and display user errors
          ⍳11::f.ExecuteJavaScript'document.getElementById("stacktrace").innerHTML =`',(⎕DMX.(Message{⍵,⍺,⍨': '/⍨×≢⍺}⎕EM EN)),'`'
     
          (fn data shape)←⍵
          w∆Table t∆Table((⍎)'UTF-8'⎕UCS fn)shape⍴∘⍙Rgb data
      }

      Handler←{
          (ref event id data fin type)←⍵
          {(⍎⍺)⍵}/0 ⎕JSON data
      }

      ∇ Init;f
          'f'⎕WC('HTMLRenderer')('Event'('WebSocketReceive' 'Handler'))('Posn'(0 0))('Size'(100 100))('HTML'(Css Js Read 'app.html'))
          ⎕DQ'f'
      ∇

:EndNameSpace