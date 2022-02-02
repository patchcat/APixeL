var colour = "rgb(0,0,0)";

const R = (p) => {
  xhr = new XMLHttpRequest();
  xhr.open("POST", "http://r/", true);
  xhr.setRequestHeader(
    "Content-Type",
    'application/javascript; charset=utf-8'
  );
  xhr.send(JSON.stringify(p));
};
const Close    = (_)    => {
  let menu = document.getElementById("menu");
  menu.innerHTML     = "";
  menu.style.visibility = "hidden";
};
const Open     = (_)    => {
  let menu = document.getElementById("menu");
  menu.style.visibility = "visible";
};
const Canvas   = (h, w) => {R(["evaluate", "Canvas", [parseInt(h), parseInt(w)]])};
const Save     = (file) => {
  var [cells, canvas] = [
    document.getElementsByTagName("td"),
    document.getElementById("canvas"),
  ];
  R([
    "evaluate",
    "Save",
    [
      file,
      [...cells].map((x) => x.style.backgroundColor),
      [canvas.rows.length, canvas.rows[0].cells.length],
    ],
  ]);
};
const Menu     = (type) => {Open();R(["evaluate", "Menu", type])};
const RunAPL   = (f)    => {
  var utf8 = unescape(encodeURIComponent(f));
  var arr = [];
  for (var i = 0; i < utf8.length; i++) arr.push(utf8.charCodeAt(i));
  var [cells, canvas] = [
    document.getElementsByTagName("td"),
    document.getElementById("canvas"),
  ];
  R([
    "evaluate",
    "RunAPL",
    [
      arr,
      [...cells].map((x) => x.style.backgroundColor),
      [canvas.rows.length, canvas.rows[0].cells.length],
    ],
  ]);
};

const Colour   = (colour) => {window.colour=colour;};
window.onload  = (_)      => {Drag(document.getElementById("menu"))};
const Drag     = (el)     => {
  el.addEventListener("mousedown", function (e) {
    offsetX = e.clientX - parseInt(window.getComputedStyle(this).left);
    offsetY = e.clientY - parseInt(window.getComputedStyle(this).top);

   mouseMoveHandler = (e) => {
      el.style.top  = e.clientY - offsetY + "px";
      el.style.left = e.clientX - offsetX + "px";
    };

    window.addEventListener("mousemove", mouseMoveHandler);
    window.addEventListener("mouseup"  , _ => {window.removeEventListener("mousemove", mouseMoveHandler)});
  });
};

function fillSquare () { this.setAttribute("style", `background-color: ${colour};`); }