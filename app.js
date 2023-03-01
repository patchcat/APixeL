var colour = "rgb(0,0,0)";

const socket = new WebSocket("ws://dyalog_root/")
const Send     = (data) => { socket.send(JSON.stringify(data)) }
const Close    = (_)    => {
  let menu = document.getElementById("menu");
  menu.innerHTML     = "";
  menu.style.visibility = "hidden";
};
const Open     = (_)    => {
  let menu = document.getElementById("menu");
  menu.style.visibility = "visible";
};
const createCanvas   = (h, w) => {Send(["createCanvas", [parseInt(h), parseInt(w)]])};
const openMenuItem     = (type) => {Open();Send(["openMenuItem", type])};
const Execute   = (f)    => {
  var utf8 = unescape(encodeURIComponent(f));
  var arr = [];
  for (var i = 0; i < utf8.length; i++) arr.push(utf8.charCodeAt(i));
  var [cells, canvas] = [
    document.getElementsByTagName("td"),
    document.getElementById("canvas"),
  ];
  Send([
    "execute",
    [
      arr,
      [...cells].map((x) => x.style.backgroundColor),
      [canvas.rows.length, canvas.rows[0].cells.length],
    ],
  ]);
};

const setColour   = (colour) => {window.colour=colour;};
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