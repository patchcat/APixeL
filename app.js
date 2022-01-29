const R = (p) => {
  xhr = new XMLHttpRequest();
  xhr.open("POST", "http://r/", true);
  xhr.setRequestHeader(
    "Content-Type",
    "application/x-www-form-urlencoded; charset=UTF-8"
  );
  xhr.send(JSON.stringify(p));
};
const Close   = (_)    => {
  let menu = document.getElementById("menu");
  menu.innerHTML     = "";
  menu.style.visibility = "hidden";
};
const Open    = (_)    => {
  let menu = document.getElementById("menu");
  menu.style.visibility = "visible";
};
const Canvas  = (h, w) => {R(["evaluate", "Canvas", [parseInt(h), parseInt(w)]])};
const Menu    = (type) => {Open();R(["evaluate", "Menu", type])};
window.onload = _      => {Drag(document.getElementById("menu"))};
const Drag    = (el)   => {
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

let colour = "#000000";
function fillSquare () { this.setAttribute("style", `background-color: ${colour};border: 1px solid ${colour};`); }