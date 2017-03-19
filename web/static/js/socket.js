// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix";

var chatInput         = document.querySelector("#chat-input");
var messagesContainer = document.querySelector("#messages");
var regex             = /^am (.+)/;
var listener, socket, channel, name, channel;

function joinChannel(newChannel){
  chatInput.addEventListener("keypress", listener = event => {
    if(event.keyCode === 13){
      if(chatInput.value){
        try{
          var payload = JSON.parse(chatInput.value);
          newChannel.push("create", {body: payload});
        }catch(err){
          newChannel.push("new_msg", {body: chatInput.value, user: name});
        }
        chatInput.value = "";
      }
    }
  });

  newChannel.on("new_msg", payload => {
    let messageItem = document.createElement("li");
    messageItem.innerText = `${payload.body}`;
    messagesContainer.appendChild(messageItem);
  });

  newChannel.on("you_are", payload => {
    console.log
    name = `${payload.body}`;
  });

  newChannel.on("new_place", payload => {
    chatInput.removeEventListener("keypress", listener);
    var newestChannel = socket.channel("area:" + payload.body, {});
    joinChannel(newestChannel);
    newChannel.leave().receive("ok", () => console.log("left!"));
  });

  newChannel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });
}

chatInput.addEventListener("keypress", listener = event => {
  if(event.keyCode === 13){
    if(regex.test(chatInput.value)){
      name = regex.exec(chatInput.value)[1];
      socket = new Socket("/socket", {params: {user: name}});
      socket.connect();

      // Now that you are connected, you can join channels with a topic:
      channel = socket.channel("area:lobby", {});
      chatInput.removeEventListener("keypress", listener);
      joinChannel(channel);
      channel.push("new_msg", {body: chatInput.value, user: name});
      chatInput.value = "";
    }else{
      chatInput.value = "";
    }
  }
});

export default socket;
