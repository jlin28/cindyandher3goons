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
  client.route = req.url.replace('/ws/','');

  client.x = 0;
  client.y = 0;
  client.z = 0;
  client.ry = 0;

  // client.send(client.id);
  // client.send(client.route);

  send(client, JSON.stringify({
    type: "assign_id",
    id: client.id,
    route: client.route
  }));

  send(client, {
    type: "world_state",
    players: getOtherPlayers(client)
  });

  broadcast({
    type: "player_joined",
    id: client.id,
    x: client.x,
    y: client.y,
    z: client.z,
    ry: client.ry
  }, client);

  client.on('message', message => {

    let data;
    try {
      data = JSON.parse(message.toString());
    } catch (err) {
      return;
    }

    if (data.type !== "position") {
      console.log("Received:", data);
    }

    if (data.type === "position") {
      client.x = Number(data.x);
      client.y = Number(data.y);
      client.z = Number(data.z);
      client.ry = Number(data.ry);

      broadcast({
        type: "player_state",
        id: client.id,
        x: client.x,
        y: client.y,
        z: client.z,
        ry: client.ry
      }, client);
    }
  });

  client.on('close', () => {
    console.log("Client has disconnected");

    broadcast({
      type: "player_left",
      id: client.id
    }, client);
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

function send(client, data) {
  if (client.readyState === WebSocket.OPEN) {
    client.send(JSON.stringify(data));
  }
}

// sends msg to all connected clients!
function broadcast(data, exceptClient) {
  for (const client of ws.clients) {
    // exceptClient to skip the player who joined
    if (client !== exceptClient && client.readyState === WebSocket.OPEN) {
      send(client, data);
    }
  }
}

function getOtherPlayers(currentClient) {
  const players = [];

  for (const client of ws.clients) {
    if (client !== currentClient && client.readyState === WebSocket.OPEN && client.id) {
      players.push({
        id: client.id,
        x: client.x || 0,
        y: client.y || 0,
        z: client.z || 0,
        ry: client.ry || 0
      });
    }
  }

  return players;
}
