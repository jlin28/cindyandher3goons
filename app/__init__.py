from flask import Flask, render_template, request, jsonify
from flask import session, redirect, url_for

app = Flask(__name__)
app.secret_key = "cindy"

@app.route("/", methods=["GET", "POST"])
def login():
    return render_template('login.html')

if __name__ == "__main__":
    app.debug = False
    app.run()
