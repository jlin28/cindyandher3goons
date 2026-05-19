import sqlite3, random
from flask import Flask, render_template, request, jsonify, session, redirect, url_for

app = Flask(__name__)
app.secret_key = "cindy"


DB_FILE="database.db"
db = sqlite3.connect(DB_FILE, check_same_thread=False)
c = db.cursor()
c.execute("""CREATE TABLE IF NOT EXISTS user(
    username TEXT,
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
    item6Count INTEGER);
    """)

c.execute("""CREATE TABLE IF NOT EXISTS item(
    name TEXT,
    desc TEXT NOT NULL,
    image TEXT NOT NULL,
    maxCount INTEGER NOT NULL);
    """)
c.execute("INSERT into item VALUES ('button', 'a circle to make your bestie feel dapper.', '', 3)")
c.execute("INSERT into item VALUES ('carrot', 'an orange vegetable grown by an aspiring botanist.', '', 1)")
c.execute("INSERT into item VALUES ('hat', 'a lid to make your bestie feel dapper.', '', 1)")
c.execute("INSERT into item VALUES ('scarf', 'knitted by a village grandma. it''s red and warm.', '', 1)")
c.execute("INSERT into item VALUES ('snowball_S', 'a small bundle of joy.', '', 99)")
c.execute("INSERT into item VALUES ('snowball_M', 'a bundle of joy.', '', 99)")
c.execute("INSERT into item VALUES ('snowball_L', 'a big fat bundle of joy.', '', 99)")

c.execute("""CREATE TABLE IF NOT EXISTS encyclopedia(
    item TEXT,
    userThatFound TEXT);
    """)

c.execute("""CREATE TABLE IF NOT EXISTS npc(
    name TEXT,
    dialogue TEXT NOT NULL,
    completedQuestUsers TEXT);
    """)
c.execute("INSERT into npc VALUES ('village grandma', '', '')")
db.commit()
db.close()

npc_dialogue = {
    "Sealius": {
        'A': {
            'dialogue': 'hey wazzup',
            'dialogue_options': {
                'who tf r u': 'B',
                'hi': 'C',
                '...': 'D'
            }
        },
        'B': {
            'dialogue': 'ok rude',
            'dialogue_options': {}
        },
        'C': {
            'dialogue': 'hihihiehe',
            'dialogue_options': {}
        },
        'D': {
            'dialogue': '...',
            'dialogue_options': {}
        }
    }
}

@app.route("/", methods=["GET", "POST"])
def start():
    session.clear()
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
                return redirect(url_for("game"))
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
            return redirect(url_for("game"))
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

    return render_template('game.html', username=session['username'])

@app.route("/exit", methods=["GET", "POST"])
def exit():
    return render_template('exit.html')

@app.route("/credit", methods=["GET", "POST"])
def credit():
    return render_template('credit.html')


if __name__ == "__main__":
    app.debug = True
    app.run()
