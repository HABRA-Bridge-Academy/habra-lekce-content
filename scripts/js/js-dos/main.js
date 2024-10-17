
var canvas = document.getElementById("jsdos");
emulators.pathPrefix = "";
var dos = Dos(canvas, {}); 
var running = false;
var displaystyle = canvas.style.display;


document.getElementById("jsdos-start").addEventListener("click", () => { if(running) return; canvas.style.visibility = "visible"; canvas.style.display = displaystyle; dos.run("/lekce2/js-dos/BM.jsdos"); running = true; console.log.log("start");});
document.getElementById("jsdos-end").addEventListener("click", () => { if(!running) return; canvas.style.visibility = "collapse"; canvas.style.display = "none"; dos.stop();  running = false; console.log.log("stop");});

canvas.style.visibility = "collapse";
canvas.style.display = "none";

document.addEventListener("keydown", (e) => {
    switch (e.key) {
      case "ArrowLeft":
      case "ArrowRight":
      case "ArrowUp":
      case "ArrowDown":
        if (running) e.preventDefault();
        break;
    }
  });