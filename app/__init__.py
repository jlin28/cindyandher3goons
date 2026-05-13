import sqlite3, random
from flask import Flask, render_template, request, jsonify, session, redirect, url_for

app = Flask(__name__)
app.secret_key = "cindy"


DB_FILE="database.db"
db = sqlite3.connect(DB_FILE, check_same_thread=False)
c = db.cursor()
c.execute("CREATE TABLE IF NOT EXISTS user(username TEXT, password TEXT, hp INTEGER NOT NULL, stamina INTEGER NOT NULL, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT, item5 TEXT, item6 TEXT, item1Count INTEGER, item2Count INTEGER, item3Count INTEGER, item4Count INTEGER, item5Count INTEGER, item6Count INTEGER);")
c.execute("CREATE TABLE IF NOT EXISTS item(name TEXT, desc TEXT NOT NULL, image TEXT NOT NULL, maxCount INTEGER NOT NULL)")
c.execute("CREATE TABLE IF NOT EXISTS encyclopedia(item TEXT, userThatFound TEXT)")
c.execute("CREATE TABLE IF NOT EXISTS npc(name TEXT, dialogue TEXT NOT NULL, completedQuestUsers TEXT)")
db.close()

@app.route("/", methods=["GET", "POST"])
def start():
    return render_template('start.html')

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method=="POST":
        username = request.form['username']
        password = request.form['password']
        db = sqlite3.connect(DB_FILE)
        c = db.cursor()
        c.execute("SELECT * FROM user WHERE username = ?", (username,))
        user_data = c.fetchone()
        db.close()

        if user_data:
            if password == user_data[1]:
                session["username"] = username
            else:
                text = 'login failed'
                return render_template('login.html', text)
        else:
            text = 'login failed'
            return render_template('login.html', text)
        return render_template('game.html')
    return render_template('login.html', text)

@app.route("/register", methods=["GET", "POST"])
def register():
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
            return render_template('register.html', text)
        else:
            db = sqlite3.connect(DB_FILE)
            c = db.cursor()
            c.execute("INSERT into user VALUES (?, ?, 100, 100)", (username, password))
            db.commit()
            db.close()
            session['username'] = username
            return render_template('game.html')
    return render_template('register.html', text)

@app.route("/game", methods=["GET", "POST"])
def game():
    return render_template('game.html')

if __name__ == "__main__":
    app.debug = False
    app.run()
