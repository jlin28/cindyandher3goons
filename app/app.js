const WebSocket = require('ws');

const PORT = 3030;
const HOST = '127.0.0.1';

const ws = new WebSocket.Server({
  port: PORT,
  host: HOST
});

ws.on('error', console.error);

ws.on('connection', function connect(client, req) {
  console.log("client has connected");
  client.id = genID();
  client.url = clientLocation(req.url);

  client.send(client.id);
  client.send(client.url);

  client.on('message', message => {
    console.log(`Received '${message}' from client`);
  })

  client.on('close', () => {
    console.log("Client has disconnected");
  });
});

function genID() {
  let id = "";

  for (let x = 0; x < 10; x++) {
    id += Math.floor(Math.random()*10);
  }

  for (const client of ws.clients) {
    if (client.id == id) {
      return genID();
      break;
    };
  }

  return id;
}

function clientLocation(url) {
  if (url === '/start') {
    return 'start';
  }
  else if (url === '/login') {
    return 'login';
  }
  else if (url === '/register') {
    return 'register';
  }
  else {
    return 'game';
  }
}
