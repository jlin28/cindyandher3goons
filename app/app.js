const WebSocket = require('ws');

const PORT = 3030;

const ws = new WebSocket.Server({
  port: PORT
});

ws.on('error', console.error);

ws.on('connection', function connect(client) {
  console.log("client has connected");

  client.on('message', message => {
    console.log(`Received '${message}' from client`);
  })

  client.on('close', () => {
    console.log("Client has disconnected");
  });
});
