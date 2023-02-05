import "phoenix_html";
import "../css/app.css"
import socket from "./socket" 
import Video from "./video"

Video.init(socket, document.getElementById("video"))
