from flask import Flask, render_template, request, jsonify
from flask import session, redirect, url_for

app = Flask(__name__)
app.secret_key = "cindy"

@app.route("/", methods=["GET", "POST"])
def start():
    return render_template('start.html')

@app.route("/login", methods=["GET", "POST"])
def login():
    return render_template('login.html')

@app.route("/register", methods=["GET", "POST"])
def register():
    return render_template('register.html')

@app.route("/game", methods=["GET", "POST"])
def game():
    return render_template('game.html')

if __name__ == "__main__":
    app.debug = False
    app.run()
