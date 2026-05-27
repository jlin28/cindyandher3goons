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
  client.username = "guest";
  client.route = req.url.replace('/ws/','');

  client.x = 0;
  client.y = 0;
  client.z = 0;
  client.ry = 0;

  // client.send(client.id);
  // client.send(client.route);

  send(client, {
    type: "assign_id",
    id: client.id,
    route: client.route,
    username: client.username
  });

  send(client, {
    type: "world_state",
    players: getOtherPlayers(client)
  });

  broadcast({
    type: "player_joined",
    id: client.id,
    username: client.username,
    x: client.x,
    y: client.y,
    z: client.z,
    ry: client.ry
  }, client);

  client.on('message', async message => {

    let data;
    try {
      data = JSON.parse(message.toString());
    } catch (err) {
      return;
    }

    if (data.type !== "position") {
      console.log("Received:", data);
    }

    if (data.type === "set_username") {
      client.username = String(data.username);

      broadcast({
        type: "player_name",
        id: client.id,
        username: client.username
      }, client);

      return;
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

    if (data.type === "dialogue") {
      console.log('i gott here');
      let res = await fetch("https://cindyandher3goons.me/" + client.route, {
      // let res = await fetch("http://127.0.0.1:5000/" + client.route, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({ type: "dialogue", npc: data.npc })
      });

      let dg = await res.json()
      send(
        client, {
          type: "dialogue",
          dialogue: dg.dialogue,
          quest_status: dg.quest_status
        }
      )
    }

    if (data.type === "add_quest") {
      console.log('i gott here');
      let res = await fetch("https://cindyandher3goons.me/" + client.route, {
      // let res = await fetch("http://127.0.0.1:5000/" + client.route, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({ type: "add_quest", npc: data.npc })
      });
    }

    if (data.type === "logout") {
      let res = await fetch("https://cindyandher3goons.me/" + client.route, {
      // let res = await fetch("http://127.0.0.1:5000/" + client.route, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({ type: "logout" })
      });

      let response = await res.json()
      console.log(response.request)
    }

    if (data.type === "add_item") {
      let res = await fetch("https://cindyandher3goons.me/" + client.route, {
      // let res = await fetch("http://127.0.0.1:5000/" + client.route, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({ type: "add_item", item: data.item, quantity: data.quantity, user: 'b' })
      });

      let success = await res.json()
      send(
        client, {
          type: "add_item",
          success: success
        }
      )
    }

    if (data.type === "fetch_inventory") {
      let res = await fetch("https://cindyandher3goons.me/" + client.route, {
      // let res = await fetch("http://127.0.0.1:5000/" + client.route, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({ type: "fetch_inventory", user: "b" })
      });

      let inventory = await res.json()
      send(
        client, {
          type: "fetch_inventory",
          inv: inventory
        }
      )
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
        username: client.username,
        x: client.x || 0,
        y: client.y || 0,
        z: client.z || 0,
        ry: client.ry || 0
      });
    }
  }

  return players;
}
