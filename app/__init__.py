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
c.execute("INSERT into item VALUES ('carrot', 'the lifes work of an aspiring botanist. it looks incredibly crunchy and irresistably tasty, taking everything in you just to not take a bite.', '', 1)")
c.execute("INSERT into item VALUES ('hat', 'a lid to make your bestie feel dapper.', '', 1)")
c.execute("INSERT into item VALUES ('red scarf', 'a scarf knitted by someone''s grandma. it''s fuzzy, warm and made with lots of love.', '', 1)")
c.execute("INSERT into item VALUES ('apple pie recipe', 'grandmas apple pie recipe. just looking at it makes your mouth water as you imagine the aroma and taste.', '', 1)")
c.execute("INSERT into item VALUES ('ice sculpture', 'sculpture made of ice in the image of sealius. it carries a strange aura. who knew he was hiding this talent all along?', '', 1)")
c.execute("INSERT into item VALUES ('old plushie', 'a plushie worn out from years of love and hugs. a token of gratitude from a small child in hopes it will bring you the same joy.', '', 1)")
c.execute("INSERT into item VALUES ('stick', 'a brown stick. its very sticky and looks like a stick. perhaps the most stick stick youve ever sticked.', '', 2)")
c.execute("INSERT into item VALUES ('slightly worn out cape', 'a welcoming gift from the village chief. he hopes it will keep you warm in this frosty climate.', '', 1)")
c.execute("INSERT into item VALUES ('flowers', 'flowers that you plucked fresh from the snow. they come in an assortment of colors, each with a slightly different scent.', '', 10)")
c.execute("INSERT into item VALUES ('pebbles', 'ooh pebble.... round, smooth, shiny pebbles...... so round... so smooth... so shiny...', '', )")
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
        'item_cap': "woah kid! you have so many items sticking out of your bag right now... i think i'll give this to you later.",
        'quest_cap': "your aura is really suffocating me right now... i think you need to do something about that before i talk to you..............",
        'quest_done': "i hope you're enjoying that sculpture of me :) it carries immense aura, i know. no need to thank me.",
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "i can already tell you don't have the inspiration yet... please hurry and find it.",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "ooh, this is exactly what i needed! to thank you, here's a sculpture of yours truly ;) enjoy!",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': 'hey wazzup!!! nice cape you got there :)',
            'dialogue_options': {
                'umm... hi? thanks..?': 'A',
                'thanks! the village chief gave it to me.': 'B',
                '*You grab your cloak in suspicion*': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': 'haha, no need to be shy! i know its a great honor to recieve a compliment from me.',
            'dialogue_options': {
                "uh... sure.....": "C",
                "i'm honored to even be breathing the same air as you!": "B",
                "what do you want from me..": "D"
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "oh, you're friendlier than i thought!",
            'dialogue_options': {
                "hmph": "C",
                "and you're a lot weirder than i thought.": "C",
                "you want something from me don't you": "D",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "hey, don't be like that! i just wanted to ask you for a favor :(",
            'dialogue_options': {

            }
        },
        'D': {
            'dialogue_type': "normal",
            'dialogue': "you wouldn't mind finding something for me, would you? i promise i'll give you something you'll love~~~ :)",
            'dialogue_options': {
                "sure!! what is it?": "E",
                "sure.. but um, you're not gonna kidnap me are you...": "C",
                "*Run away!*": "F"
            }
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': "i've been feeling really uninspired lately :( hit a bit of a block, if you will. if you could find me things that would spark my imagination, i'll reward you greatly!",
            'dialogue_options': {
                "okay, i'll be back soon.": "G",
                "nope, i'm out.": "F"
            }
        },
        'F': {
            'dialogue_type': "normal",
            'dialogue': "hey kid! come back :(",
            'dialogue_options': {}
        },
        'G': {
            'dialogue_type': "quest",
            'dialogue': "thanks kid! i'll be waiting here for you.",
            'dialogue_options': {}
        },
    },
    "Town Chief": {
        'item_cap': "Someone as little as you carrying so much around already? You should see me when you've lightened that load, it could stunt your growth.",
        'quest_cap': "Child, you look like you have too much going on right now. I won't go anywhere, so take care of what you have first.",
        'quest_done': "You look just like my son when he was little...",
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "Come back when you've found the house!",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "I see you've found the house! As a welcoming gift, heres a cape. It's a bit old I know, but I want to you stay warm in this cold climate.",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "Hey kid, I've never seen you around before... Are you new?",
            'dialogue_options': {
                "No. I don't know what you're talking about.": 'A',
                'Yeah... Do you have somewhere I can stay?': 'B',
                '*Run away!*': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "Hohoho! Don't worry kid, we won't kick you out. I know you're not from here.",
            'dialogue_options': {
                "How?": "B",
                "*Run away!*": "C"
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "It's been a long time since we've had anyone new in the village. If my memory serves me right, there should be one empty house. Once you've found it, come back to me!",
            'dialogue_options': {
                "Okay...": "D",
                "Maybe later...": "E"
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': 'Wait, where are you going?!',
            'dialogue_options': {}
        },
        'D':{
            'dialogue_type': "quest",
            'dialogue': "I'll be waiting with a gift hohoho...",
            'dialogue_options': {}
        },
        'E':{
            'dialogue_type': "normal",
            'dialogue': "Take your time kid.",
            'dialogue_options': {}
        }
    },
    "Buntanist": {
        'item_cap': "eep! don't put my prized carrot in there! you'll ruin it immediately!!!",
        'quest_cap': "i don't want to bother you with my request. you look just as busy as i do... ",
        'quest_done': "oh, seeing these plants thriving again makes me so happy...",
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "i hope it isn't too late.. i hope it isn't too late... i hope it isn't too late....",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "you really found it! i'm so incredibly grateful to you, thank you for helping me this much! um, i've been working on growing this carrot for the past few years... it's a token of my gratitude!",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "hi... um, do you need something? i'm swamped right now, so i don't think i can help you...",
            'dialogue_options': {
                "hi!! i just wanted to know more about plants. i see you grow a lot of them!": 'A',
                "it's amazing how you can grow so many plants despite the cold!": 'B',
                "i think your plants are dying...": 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "omg, a fellow plant enjoyer! i'd love to tell you about them but as you can see, they're in such a sorry state right now. i don't know what to do...",
            'dialogue_options': {
                "aww, is there anything i can do to help?": "D",
                "these poor plants :(": "C",
                "i don't think i can help you here..": "G",
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "not really... as you can see, they're all dying and i don't know why! at this rate, all these plants are done for...",
            'dialogue_options': {
                "you need to do something about this!": "C",
                "nooooooo, not the plants! how can i help???": "D",
                "i think they're already too far gone...": "E",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "i know... but i can't fix it! i'm such a failure of a botanist :(",
            'dialogue_options': {
                "don't worry, i'm sure we can find a way to fix it!": "D",
                "sorry, but i can't fix it either.": "G",
                "yeah, you kind of are a failure.": "E",
            }
        },
        'D': {
            'dialogue_type': "normal",
            'dialogue': "i think i've heard of this thing you can sprinkle on your plants to revitalize them, but it's hidden in the mountains... do you think you can get it for me?",
            'dialogue_options': {
                "of course! leave it to me.": "F",
                "i don't think i can.": "G",
            }
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': '*sobs*',
            'dialogue_options': {}
        },
        'F': {
            'dialogue_type': "quest",
            'dialogue': 'thank you so much, how could i ever repay you? T-T',
            'dialogue_options': {}
        },
        'G': {
            'dialogue_type': "normal",
            'dialogue': "it's okay... thank you for listening to my troubles...",
            'dialogue_options': {}
        }
    },
    "Bobby": {
        'item_cap': "",
        'quest_cap': "",
        'quest_done": "i hope you love that plushie as much as i love the pebbles you gave me!",
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "ahhhh! i can't wait any longer!!!!!!! i need the pebbles!!!!!!!!!",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "omg!! they're just as perfect and beautiful as i thought they would be!! so... uh, take this plushie as thanks! i've never seen you around before and i get the feeling you dont have many friends... ",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': 'hey you! have you seen a pebble before?',
            'dialogue_options': {
                'uh, why do you want to know?': 'A',
                "who hasn't? they're everywhere!": 'B',
                '..?': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "i've heard so many wonderful things about pebbles! i'd like to have one of my own someday..",
            'dialogue_options': {
                "what's a pebble?": "C",
                "i love pebbles too! want me to go get some for you?": "D",
                "they really aren't as great as you think they are..." : "E",
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': 'my mom never lets me out to play...',
            'dialogue_options': {
                "aww, that's so sad :(" : "F",
                "i can get you some if you want": "D",
                "sucks to suck lol" : "E",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "you don't know about pebbles???",
            'dialogue_options': {}
        },
        'D': {
            'dialogue_type': "quest",
            'dialogue': "omg yes!!! you're the bestest best bestie in the whole world!!!!!",
            'dialogue_options': {}
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': "hey!! i don't want to talk to you anymore, you meanie!",
            'dialogue_options': {}
        },
        'F': {
            'dialogue_type': "normal",
            'dialogue': "i know.... can you get some pebbles for me?",
            'dialogue_options': {
                "of course!": "D",
                "nah, i don't wanna": "E",
                "i'm a bit busy right now...": "G"
            }
        },
        'G': {
            'dialogue_type': "normal",
            'dialogue': "aww......",
            'dialogue_options': {}
        },
    },
    
}

"""
template
    "": {
        'item_cap': "",
        'quest_cap': "",
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': '',
            'dialogue_options': {
                '': 'A',
                '': 'B',
                '': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': '',
            'dialogue_options': {}
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': '',
            'dialogue_options': {}
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': '',
            'dialogue_options': {}
        }
    },
"""

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
def stash_to_inventory(username, item_name, item_number):
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

    if item_counts is None or items is None:
        db.close()
        return False

    if item_name in items:
        index = items.index(item_name)
        c.execute(f"SELECT item{index+1}Count FROM user WHERE username = ?", (username,))
        current_item_count = c.fetchone()[0]

        c.execute("SELECT maxCount FROM item WHERE name = ?", (item_name,))
        max_item_count = c.fetchone()[0]

        if current_item_count + item_number <= max_item_count:
            c.execute(f"UPDATE user SET item{index+1}Count = ? WHERE username = ?", (current_item_count + item_number, username))
            db.commit()
            db.close()
            return True

    # assumption is made that you cannot keep an inventory space for zero of an item
    for n in range(0,6):
        if item_counts[n] == 0:
            c.execute(f"""UPDATE user
                SET item{n+1} = ?, item{n+1}Count = ?
                WHERE username = ?
                """, (item_name, item_number, username)
            )
            db.commit()
            db.close()
            return True

    db.commit()
    db.close()
    return False

def fetch_inventory(username):
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

    inventory = {}
    for n in range(0,6):
        inventory[n] = {
                "item": items[n],
                "count": item_counts[n]
            }

    db.commit()
    db.close()
    return inventory

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

    if request.method == "POST":
        body = request.get_json()

        if body.get('type') == 'dialogue':
            npc = body.get('npc')
            return jsonify(npc_dialogue[npc])

        if body.get('type') == 'logout':
            session.pop('username')
            return redirect(url_for("login"))

        if body.get('type') == 'add_item':
            user = body.get('user')
            item = body.get('item')
            quantity = body.get('quantity')

            return jsonify(stash_to_inventory(user, item, quantity))

        if body.get('type') == 'fetch_inventory':
            user = body.get('user')

            return jsonify(fetch_inventory(user))

    if "username" not in session:
        return redirect(url_for("login"))

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
