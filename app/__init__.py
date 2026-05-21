import sqlite3, random
from flask import Flask, render_template, request, jsonify, session, redirect, url_for

app = Flask(__name__)
app.secret_key = "cindy"


DB_FILE="database.db"
db = sqlite3.connect(DB_FILE, check_same_thread=False)
c = db.cursor()
c.execute("PRAGMA foreign_keys = ON;")
c.execute("""CREATE TABLE IF NOT EXISTS user(
    username TEXT PRIMARY KEY,
    password TEXT,
    hp INTEGER NOT NULL,
    stamina INTEGER NOT NULL,
    item1 TEXT,
    item2 TEXT,
    item3 TEXT,
    item4 TEXT,
    item5 TEXT,
    item6 TEXT,
    item1Count INTEGER,
    item2Count INTEGER,
    item3Count INTEGER,
    item4Count INTEGER,
    item5Count INTEGER,
    item6Count INTEGER,
    questsCompleted STRING,
    questsActive STRING,
    FOREIGN KEY (item1) references item(name),
    FOREIGN KEY (item2) references item(name),
    FOREIGN KEY (item3) references item(name),
    FOREIGN KEY (item4) references item(name),
    FOREIGN KEY (item5) references item(name),
    FOREIGN KEY (item6) references item(name)
    );
    """)

c.execute("""CREATE TABLE IF NOT EXISTS item(
    name TEXT PRIMARY KEY,
    desc TEXT NOT NULL,
    image TEXT NOT NULL,
    maxCount INTEGER NOT NULL
    );
    """)
c.execute("INSERT into item VALUES ('button', 'a circle to make your bestie feel dapper.', '', 3)")
c.execute("INSERT into item VALUES ('carrot', 'an orange vegetable grown by an aspiring botanist. it looks crunchy and tasty, though you''re not sure if you should eat it.', '', 1)")
c.execute("INSERT into item VALUES ('hat', 'a lid to make your bestie feel dapper.', '', 1)")
c.execute("INSERT into item VALUES ('red scarf', 'a scarf knitted by someone''s grandma. it''s fuzzy and warm.', '', 1)")
c.execute("INSERT into item VALUES ('apple pie recipe', 'grandmas apple pie recipe. just looking at it makes your mouth water as you imagine the aroma and taste.', '', 1)")
c.execute("INSERT into item VALUES ('ice sculpture', 'sculpture made of ice in the image of sealius. who knew he was hiding this talent all along?', '', 1)")
c.execute("INSERT into item VALUES ('old plushie', 'a plushie worn out from years of love and hugs. a token of gratitude from a small child in hopes it will bring you the same joy.', '', 1)")
c.execute("INSERT into item VALUES ('stick', 'a brown stick. its very sticky and looks like a stick. perhaps the most stick stick youve ever sticked.', '', 2)")
c.execute("INSERT into item VALUES ('slightly worn out cape', 'a welcoming gift from the village chief. he hopes it will keep you warm in this frosty climate.', '', 1)")
c.execute("INSERT into item VALUES ('snowball_S', 'a small bundle of joy.', '', 99)")
c.execute("INSERT into item VALUES ('snowball_M', 'a bundle of joy.', '', 99)")
c.execute("INSERT into item VALUES ('snowball_L', 'a big fat bundle of joy.', '', 99)")

c.execute("""CREATE TABLE IF NOT EXISTS encyclopedia(
    item TEXT,
    userThatFound TEXT,
    FOREIGN KEY (item) references items(name),
    FOREIGN KEY (userThatFound) references user(username)
    );
    """)

c.execute("""CREATE TABLE IF NOT EXISTS npc(
    name TEXT PRIMARY KEY,
    questName TEXT,
    questReq TEXT
    );
    """)
c.execute("INSERT into npc VALUES ('village grandma', '', '')")
db.commit()
db.close()

npc_dialogue = {
    "Sealius": {
        'quest_inactive': {
            'dialogue': 'hey wazzup!!! nice cape you got there :)',
            'dialogue_options': {
                'umm... hi?': 'A',
                '': 'B',
                '...': 'C'
            }
        },
        'A': {
            'dialogue': 'ok rude',
            'dialogue_options': {}
        },
        'B': {
            'dialogue': 'hihihiehe',
            'dialogue_options': {}
        },
        'C': {
            'dialogue': '...',
            'dialogue_options': {}
        }
    },
    "Town Chief": {
        'quest_in_progress': {
            'dialogue': "Come back when you've found the house!",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue': "You look just like my son when he was little...",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue': "Hey kid, I've never seen you around before... Are you new?",
            'dialogue_options': {
                "No. I don't know what you're talking about.": 'A',
                'Yeah... Do you have somewhere I can stay?': 'B',
                'Run away!': 'C'
            }
        },
        'A': {
            'dialogue': "Hohoho! Don't worry kid, we won't kick you out. I know you're not from here.",
            'dialogue_options': {
                "How?": "B",
                "Run away!": "C"
            }
        },
        'B': {
            'dialogue': "It's been a long time since we've had anyone new in the village. If my memory serves me right, there should be one empty house. Once you've found it, come back to me!",
            'dialogue_options': {
                "Okay...": "D",
                "Maybe later...": "E"
            }
        },
        'C': {
            'dialogue': 'Wait, where are you going?!',
            'dialogue_options': {}
        },
        'D':{
            'dialogue': "I'll be waiting with a gift hohoho...",
            'dialogue_options': {}
        },
        'E':{
            'dialogue': "Take your time kid.",
            'dialogue_options': {}
        }
    },
    "": {
        'quest_in_progress': {
            'dialogue': "",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue': "",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue': '',
            'dialogue_options': {
                '': 'B',
                '': 'C',
                '': 'D'
            }
        },
        'B': {
            'dialogue': '',
            'dialogue_options': {}
        },
        'C': {
            'dialogue': '',
            'dialogue_options': {}
        },
        'D': {
            'dialogue': '',
            'dialogue_options': {}
        }
    },
}

# return list of quests completed for the logged in user
def questsCompleted_list():
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT questsCompleted FROM user WHERE username = ?", (username,))
    questsCompleted_string = c.fetchone()
    db.commit()
    db.close()
    return questsCompleted_string.split('&')

# return list of quests active for the logged in user
def questsActive_list():
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT questsActive FROM user WHERE username = ?", (username,))
    questsActive_string = c.fetchone()
    db.commit()
    db.close()
    return questsActive_string.split('&')

# return boolean (true if less than 3 active quests)
def questsAvailable():
    if len(questsActive_list()) == 3:
        return False
    return True

# return boolean reflecting whether the inventory is full
def stash_to_inventory(item_name, item_number):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()

    c.execute("""SELECT
        item1Count,
        item2Count,
        item3Count,
        item4Count,
        item5Count,
        item6Count
        FROM user WHERE username = ?""", (username,))
    item_counts = c.fetchone()

    c.execute("""SELECT
        item1,
        item2,
        item3,
        item4,
        item5,
        item6
        FROM user WHERE username = ?""", (username,))
    items = c.fetchone()

    if item_name in items:
        index = items.index(item_name)
        c.execute(f"SELECT item{index}Count FROM user WHERE username = ?", (username,))
        current_item_count = c.fetchone()

        c.execute("SELECT maxCount FROM item WHERE name = ?", (item_name,))
        max_item_count = c.fetchone()

        if current_item_count + item_number <= max_item_count:
            c.execute("UPDATE user SET ? = ? WHERE username = ?", (f"item{index}Count", current_item_count + item_number, username))
            return True

    # assumption is made that you cannot keep an inventory space for zero of an item
    for n in range(0,6):
        if item_counts[n] == 0:
            c.execute("""UPDATE user
                SET ? = ?,
                SET ? = ?
                """, (f"item{n}", item_name, f"item{n}Count", item_number)
            )
            db.commit()
            db.close()
            return True

    db.commit()
    db.close()
    return False

@app.route("/", methods=["GET", "POST"])
def start():
    return render_template('start.html')

@app.route("/login", methods=["GET", "POST"])
def login():
    text = ''
    if request.method=="POST":
        username = request.form['username']
        password = request.form['password']
        db = sqlite3.connect(DB_FILE)
        c = db.cursor()
        c.execute("SELECT * FROM user WHERE username = ?", (username,))
        user_data = c.fetchone()
        db.commit()
        db.close()

        if user_data:
            if password == user_data[1]:
                session["username"] = username
                return redirect(url_for("start"))
            else:
                text = 'login failed'
                return render_template('login.html', text=text)
        else:
            text = 'login failed'
            return render_template('login.html', text=text)

        return render_template('login.html', text='')
    return render_template('login.html', text=text)

@app.route("/register", methods=["GET", "POST"])
def register():
    text = ''
    if request.method=="POST":
        username = request.form['username']
        password = request.form['password']
        db = sqlite3.connect(DB_FILE)
        c = db.cursor()
        c.execute("SELECT * FROM user WHERE username = ?", (username,))
        user_data = c.fetchone()
        db.close()

        if user_data:
            text='this username is taken'
            return render_template('register.html', text=text)
        else:
            db = sqlite3.connect(DB_FILE)
            c = db.cursor()
            c.execute("INSERT into user VALUES (?, ?, 100, 100, '', '', '', '', '', '', 0, 0, 0, 0, 0, 0)", (username, password))
            db.commit()
            db.close()
            session['username'] = username
            return redirect(url_for("start"))
    return render_template('register.html', text=text)

@app.route("/game", methods=["GET", "POST"])
def game():
    if "username" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        body = request.get_json()

        if body.get('type') == 'dialogue':
            npc = body.get('npc')
            return jsonify(npc_dialogue[npc])

        if body.get('type') == 'logout':
            session.pop('username')
            return redirect(url_for("login"))

        if body.get('type') == 'add_item':
            item = body.get('item')
            quantity = body.get('quantity')

            return stash_to_inventory(item, quantity)

    return render_template('game.html', username=session['username'])

@app.route("/exit", methods=["GET", "POST"])
def exit():
    session.clear()
    return render_template('exit.html')

@app.route("/credit", methods=["GET", "POST"])
def credit():
    return render_template('credit.html')


if __name__ == "__main__":
    app.debug = True
    app.run()
