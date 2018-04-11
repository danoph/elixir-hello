// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {
  params: { user_id: window.location.search.split("=")[1] }
})

function renderOnlineUsers(presences) {
  let response = ""

  Presence.list(presences, (id, {metas: [first, ...rest]}) => {
    let count = rest.length + 1
    let name;

    if (id !== "undefined") {
      name = id;
    } else {
      name = 'Anonymous';
    }

    response += `<li>${name} (${count})</li>`
  })

  document.querySelector("#users-list").innerHTML = response
}

socket.connect()

let presences = {}

let channel = socket.channel("room:lobby", {})

channel.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  renderOnlineUsers(presences)
})

channel.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  renderOnlineUsers(presences)
})

//channel.join()

//socket = assign(socket, :user, msg["user"])

//let channel           = socket.channel("room:lobby", {})
let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

chatInput.addEventListener("keypress", event => {
  if(event.keyCode === 13){
    channel.push("new_msg", {body: chatInput.value})
    chatInput.value = ""
  }
})

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li")
  messageItem.innerText = `[${Date()}] ${payload.body}`
  messagesContainer.appendChild(messageItem)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
