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
    questsCompleted TEXT,
    questsActive TEXT,
    cape BOOLEAN,
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
c.execute("INSERT OR IGNORE INTO item VALUES ('button', 'a circle to make your bestie feel dapper.', '', 3)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('carrot', 'the lifes work of an aspiring botanist. it looks incredibly crunchy and irresistably tasty, taking everything in you just to not take a bite.', '', 1)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('hat', 'a lid to make your bestie feel dapper.', '', 1)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('red scarf', 'a scarf knitted by someone''s grandma. it''s fuzzy, warm and made with lots of love.', '', 1)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('apple pie recipe', 'grandmas apple pie recipe. just looking at it makes your mouth water as you imagine the aroma and taste.', '', 1)")
c.execute("INSERT OR IGNORE INTO item VALUES ('ice sculpture', 'sculpture made of ice in the image of sealius. it carries a strange aura. who knew he was hiding this talent all along?', '', 1)")
c.execute("INSERT OR IGNORE INTO item VALUES ('old plushie', 'a plushie worn out from years of love and hugs. a token of gratitude from a small child in hopes it will bring you the same joy.', '', 1)")
c.execute("INSERT OR IGNORE INTO item VALUES ('stick', 'a brown stick. its very sticky and looks like a stick. perhaps the most stick stick youve ever sticked.', '', 99)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('slightly worn out cape', 'a welcoming gift from the village chief. he hopes it will keep you warm in this frosty climate.', '', 1)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('flowers', 'flowers that you plucked fresh from the snow. they come in an assortment of colors, each with a slightly different scent.', '', 10)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('pebbles', 'ooh pebble.... round, smooth, shiny pebbles...... so round... so smooth... so shiny...', '', 99)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('apples', 'fresh(?), plump, juicy round red apples. you found them on the floor, but they look suspiciously pristine....', '', 99)") #model
c.execute("INSERT OR IGNORE INTO item VALUES ('special powder', 'powder you found at the top of the mountain peaks. it''s rumored to be a legendary fertilizer but looks suspiciously white and powdery, like something else you know...', '', 1)") #model oops
c.execute("INSERT OR IGNORE INTO item VALUES ('snowball_S', 'a small bundle of joy.', '', 99)")
c.execute("INSERT OR IGNORE INTO item VALUES ('snowball_M', 'a bundle of joy.', '', 99)")
c.execute("INSERT OR IGNORE INTO item VALUES ('snowball_L', 'a big fat bundle of joy.', '', 99)")

c.execute("""CREATE TABLE IF NOT EXISTS encyclopedia(
    item TEXT,
    userThatFound TEXT,
    FOREIGN KEY (item) references item(name),
    FOREIGN KEY (userThatFound) references user(username)
    );
    """)

c.execute("""CREATE TABLE IF NOT EXISTS npc(
    name TEXT PRIMARY KEY,
    questName TEXT,
    questDesc TEXT,
    questReq TEXT,
    questType TEXT,
    questRequiredAmount INTEGER
    );
    """)

c.execute("""CREATE TABLE IF NOT EXISTS snowmen(
    player TEXT,
    id INTEGER PRIMARY KEY,
    x_coord REAL,
    y_coord REAL,
    z_coord REAL,
    x_rot REAL,
    y_rot REAL,
    z_rot REAL,
    button BOOLEAN,
    carrot BOOLEAN,
    hat BOOLEAN,
    red_scarf BOOLEAN,
    stick1 BOOLEAN,
    stick2 BOOLEAN,
    pebble1 BOOLEAN,
    pebble2 BOOLEAN,
    FOREIGN KEY (player) references user(username)
    );
    """)
c.execute("INSERT OR IGNORE INTO npc VALUES ('Sealius', 'A Spark of Inspiration', 'Help Sealius out of his slump---though you don''t even know why you''re doing this', 'flowers', 'fetch', 5)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Town Chief', 'A Warm Welcome', 'Find the house the Town Chief set aside for you', 'house', 'go', 1)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Buntanist', 'A Bunny''s Cry For Help', 'Save Buntanist''s plants!', 'special powder', 'fetch', 1)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Bobby', 'Pebbles, Pebbles, Pebbles!', 'Find those pebbles! What''s so cool about pebbles anyways?', 'pebbles', 'fetch', 5)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Mr. Cheddar', 'The Former Mobster''s request', 'A nice warm apple pie could warm anyone''s heart', 'apple pie recipe', 'fetch', 1)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Daisy', 'A Final Farewell', 'She seemed quite agitated, better find those flowers before this whole place is flooded!', 'flowers', 'fetch', 10)")
c.execute("INSERT OR IGNORE INTO npc VALUES ('Mabel', 'Just Like The Old Days', 'How are apples growing here anyways?', 'apples', 'fetch', 25)")
db.commit()
db.close()

npc_dialogue = {
    "Sealius": {
        'item_cap': {
            'dialogue': "Woah kid! You have so many items sticking out of your bag right now... I think I'll give this to you later.",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "Your aura is really suffocating me right now... I think you need to do something about that before I talk to you..............",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "I hope you're enjoying that sculpture of me :) It carries immense aura, I know. No need to thank me.",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "I can already tell you don't have the inspiration yet... please hurry and find it.",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "Ooh, this is exactly what I needed! To thank you, here's a sculpture of yours truly ;) Enjoy!",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': 'Hey wazzup!!! Nice cape you got there :)',
            'dialogue_options': {
                'Umm... hi? Thanks..?': 'A',
                'Thanks! The village chief gave it to me.': 'B',
                '*You grab your cloak in suspicion*': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': 'Haha, no need to be shy! I know its a great honor to recieve a compliment from me.',
            'dialogue_options': {
                "Uh... sure.....": "C",
                "I'm honored to even be breathing the same air as you!": "B",
                "What do you want from me..": "D"
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "Oh, you're friendlier than I thought!",
            'dialogue_options': {
                "Hmph.": "C",
                "And you're a lot weirder than i thought.": "C",
                "You want something from me don't you": "D",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "Hey, don't be like that! I just wanted to ask you for a favor :(",
            'dialogue_options': {
                "Ok, fine. What is it.": "E",
                "*Run away!*": "F"
            }
        },
        'D': {
            'dialogue_type': "normal",
            'dialogue': "You wouldn't mind finding something for me, would you? I promise I'll give you something you'll love~~~ :)",
            'dialogue_options': {
                "Sure!! What is it?": "E",
                "Sure.. but um, you're not gonna kidnap me are you...": "C",
                "*Run away!*": "F"
            }
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': "I've been feeling really uninspired lately :( Hit a bit of a block, if you will. If you could find me things that would spark my imagination, I'll reward you greatly!",
            'dialogue_options': {
                "okay, i'll be back soon.": "G",
                "nope, i'm out.": "F"
            }
        },
        'F': {
            'dialogue_type': "normal",
            'dialogue': "Hey kid! Come back!!!! :(",
            'dialogue_options': {}
        },
        'G': {
            'dialogue_type': "quest",
            'dialogue': "Thanks kid! I'll be waiting here for you.",
            'dialogue_options': {}
        },
    },
    "Town Chief": {
        'item_cap': {
            'dialogue': "Someone as little as you carrying so much around already? You should see me when you've lightened that load, it could stunt your growth.",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "Child, you look like you have too much going on right now. I won't go anywhere, so take care of what you have first.",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "You look just like my son when he was little...",
            'dialogue_options': {}
        },
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
        'item_cap': {
            'dialogue': "Eep! Don't put my prized carrot in there! you'll ruin it immediately!!!",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "I don't want to bother you with my request. You look just as busy as i do... ",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "Oh, seeing these plants thriving again makes me so happy...",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "I hope it isn't too late.. I hope it isn't too late... I hope it isn't too late....",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "You really found it! I'm so incredibly grateful to you, thank you for helping me this much! Um, I've been working on growing this carrot for the past few years... it's a token of my gratitude!",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "Hi... um, do you need something? I'm swamped right now, so i don't think I can help you...",
            'dialogue_options': {
                "Hi!! I just wanted to know more about plants. I see you grow a lot of them!": 'A',
                "It's amazing how you can grow so many plants despite the cold!": 'B',
                "I think your plants are dying...": 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "Wow, a fellow plant enjoyer! I'd love to tell you about them but as you can see, they're in such a sorry state right now. I don't know what to do...",
            'dialogue_options': {
                "Aww, is there anything I can do to help?": "D",
                "These poor plants :(": "C",
                "I don't think I can help you here..": "G",
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "Not really... as you can see, they're all dying and I don't know why! At this rate, all these plants are done for...",
            'dialogue_options': {
                "You need to do something about this!": "C",
                "nooooooo, not the plants! How can i help???": "D",
                "I think they're already too far gone...": "E",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "I know... but I can't fix it! I'm such a failure of a botanist :(",
            'dialogue_options': {
                "Don't worry, I'm sure we can find a way to fix it!": "D",
                "Sorry, but i can't fix it either.": "G",
                "Yeah, you kind of are a failure.": "E",
            }
        },
        'D': {
            'dialogue_type': "normal",
            'dialogue': "I think I've heard of this thing you can sprinkle on your plants to revitalize them, but it's hidden in the mountains... do you think you can get it for me?",
            'dialogue_options': {
                "Of course! Leave it to me.": "F",
                "I don't think I can.": "G",
            }
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': '*sobs*',
            'dialogue_options': {}
        },
        'F': {
            'dialogue_type': "quest",
            'dialogue': 'Thank you so much, how could I ever repay you? T-T',
            'dialogue_options': {}
        },
        'G': {
            'dialogue_type': "normal",
            'dialogue': "It's okay... thank you for listening to my troubles...",
            'dialogue_options': {}
        }
    },
    "Bobby": {
        'item_cap': {
            'dialogue': "Hey, give your new friend some respect and clear that backpack!",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "Oh but you look so busy... it's ok don't mind me, I'll find my own pebbles...",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "I hope you love that plushie as much as I love the pebbles you gave me!",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "Ahhhh! I can't wait any longer!!!!!!! I need the pebbles!!!!!!!!!",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "Omg!! They're just as perfect and beautiful as I thought they would be!! So... uh, take this plushie as thanks! I've never seen you around before and I get the feeling you dont have many friends... ",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': 'Hey, you! Have you seen a pebble before?',
            'dialogue_options': {
                'Uh, why do you want to know?': 'A',
                "Who hasn't? They're everywhere!": 'B',
                '..?': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "I've heard so many wonderful things about pebbles! I'd like to have one of my own someday..",
            'dialogue_options': {
                "What's a pebble?": "C",
                "I love pebbles too! Want me to go get some for you?": "D",
                "They really aren't as great as you think they are..." : "E",
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': 'My mom never lets me out to play...',
            'dialogue_options': {
                "Aww, that's so sad :(" : "F",
                "I can get you some if you want": "D",
                "sucks to suck lol" : "E",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "You don't know about pebbles???",
            'dialogue_options': {}
        },
        'D': {
            'dialogue_type': "quest",
            'dialogue': "Omg yes!!! You're the bestest best bestie in the whole world!!!!!",
            'dialogue_options': {}
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': "Hey!! I don't want to talk to you anymore, you meanie!",
            'dialogue_options': {}
        },
        'F': {
            'dialogue_type': "normal",
            'dialogue': "I know.... can you get some pebbles for me?",
            'dialogue_options': {
                "Of course!": "D",
                "Nah, I don't wanna": "E",
                "I'm a bit busy right now...": "G"
            }
        },
        'G': {
            'dialogue_type': "normal",
            'dialogue': "Aww......",
            'dialogue_options': {}
        },
    },
    "Mr. Cheddar": {
        'item_cap': {
            'dialogue': "Woah there! Not sure if I want my hat to get squished like that in your bag.",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "Kid, you look so busy you might just explode right here. Go finish whatever you have going on.",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "Mmm, it tastes exactly like how grandma used to make it...",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "Granny, I wish you were still with us...",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "You really got a recipe! Thanks kid, this means a lot to me. I'll try it out and get back to you... oh, before I forget, here's a small gift for you.",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "Yoooo, what's up kid?",
            'dialogue_options': {
                "Hey!": 'A',
                'Uh... hi?': 'B',
                '...': 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "You know, ever since I moved here, I haven't been able to taste my grandma's apple pie. Any apple pies I make pale in comparison...",
            'dialogue_options': {
                "I can try to find a recipe for you!": "D",
                "Have you tried asking around for help?": "E",
                "I can't bake either...": "F"
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "Don't be so scared kid! I don't bite.",
            'dialogue_options': {
                "You just have that scary feel...": "A",
                "Are you sure...": "C",
                "That's what they all say.......": "C",
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "Riiiight, stranger danger. Don't worry, I dont kidnap people anymore.",
            'dialogue_options': {
                "Uh huh...": "A",
                "Cool!": "A",
                "...": "A",
            }
        },
        'D': {
            'dialogue_type': "quest",
            'dialogue': "Really? Thanks a lot kid. Maybe I can finally get a taste of home..",
            'dialogue_options': {}
        },
        'E': {
            'dialogue_type': "normal",
            'dialogue': "Well, I've tried... but the townspeople seem too scared to talk to me.",
            'dialogue_options': {
                "Hey, I can ask around for you!": "D",
                "Yeah, I can see why they'd say that": "F",
                "I'm scared too...": "G"
            }
        },
        'F': {
            'dialogue_type': "normal",
            'dialogue': "If it doesn't bother you too much kid, do you think you could ask around for me?",
            'dialogue_options': {
                "Yeah, sure thing!": "D",
                "No, I can't do that right now...": "G",
            }
        },
        'G': {
            'dialogue_type': "normal",
            'dialogue': "That's okay kid, I'll keep trying by myself.",
            'dialogue_options': {}
        },
    },
    "Daisy": {
        'item_cap': {
            'dialogue': "*sob* Grandma's scarf *sob* doesn't fit!!!! *sob*",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "No nevermind... *sniff* Grandma wouldn't want me to bother you *sob*",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "Grandma, I know you would've loved these flowers...",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "*sniff* *sob*",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "Thank you so much... *sniff* These were my grandma's favorite flowers... *sniff* now I can plant them on her grave... You can have this scarf she *sniff* made, looking at it makes me too sad now *sobs*",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "*sniff* Do you think you can get some red *sniff* flowers for me.... I couldn't find them *sniff* no matter where I looked...",
            'dialogue_options': {
                "Sure!": 'A',
                "Uh.. why?": 'B',
                "No thanks...": 'C'
            }
        },
        'A': {
            'dialogue_type': "quest",
            'dialogue': "thanks... *sniff*",
            'dialogue_options': {}
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "*sobs*",
            'dialogue_options': {
                "I will I will!! Stop crying!": 'A',
                "*Leave quietly*": 'C'
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "*sob* I told you *sniff* you couldn't do backflips anymore grandma *sob*",
            'dialogue_options': {}
        }
    },
    "Mabel": {
        'item_cap': {
            'dialogue': "Oh my, I don't think you can hold any more things!",
            'dialogue_options': {}
        },
        'quest_cap': {
            'dialogue': "Oh dear, you look so busy... I won't bother you with my request.",
            'dialogue_options': {}
        },
        'quest_done': {
            'dialogue': "Hi sweetie! Come in, we can share this apple pie together.",
            'dialogue_options': {}
        },
        'quest_in_progress': {
            'dialogue_type': "normal",
            'dialogue': "*hums* hmmm hm hmm, my handwriting is a lot shakier than I remember...",
            'dialogue_options': {}
        },
        'quest_completed': {
            'dialogue_type': "normal",
            'dialogue': "Oh my, those are the freshest apples I've seen in years! Thank you so much sweetie... here's my apple pie recipe, I'll make some for you myself the next time you visit.",
            'dialogue_options': {}
        },
        'quest_inactive': {
            'dialogue_type': "normal",
            'dialogue': "Hello dear, have you seen any apples around recently?",
            'dialogue_options': {
                "Yeah! do you need some?": 'A',
                "I dont think so, but I can look.": 'B',
                "Nope.": 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "If that doesn't bother you too much dear, I'd greatly appreciate it...",
            'dialogue_options': {
                "No problem granny! I'll be back with them soon.": "D",
                "On second thought, I don't think I have time...": "C",
            }
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "Is that alright with you dear? I don't want to take up too much of your time...",
            'dialogue_options': {
                "Yeah, it's not a problem!": "D",
                "Sorry, i'll get back to you later...": "C"
            }
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "Oh, that's fine dear. I'll go out looking myself when the weather gets better...",
            'dialogue_options': {}
        },
        'D': {
            'dialogue_type': "quest",
            'dialogue': "Thank you so much dear... While you get those, I'll prepare a little gift for you!",
            'dialogue_options': {}
        },
    },
}

"""
template
    "": {
        'item_cap': "",
        'quest_cap': "",
        "quest_done": "",
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
            'dialogue': "",
            'dialogue_options': {
                "": 'A',
                "": 'B',
                "": 'C'
            }
        },
        'A': {
            'dialogue_type': "normal",
            'dialogue': "",
            'dialogue_options': {}
        },
        'B': {
            'dialogue_type': "normal",
            'dialogue': "",
            'dialogue_options': {}
        },
        'C': {
            'dialogue_type': "normal",
            'dialogue': "",
            'dialogue_options': {}
        }
    },
"""

# return 2D list of snowmen belonging a player
# BOOLEANS ARE REPRESENTED BY 0 OR 1
def snowman_collection(player):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT * FROM snowmen WHERE player = ?", (player,))
    snowman_collection = c.fetchone()
    db.commit()
    db.close()
    return snowman_collection

# return list of quests completed for the logged in user
def questsCompleted_list(user):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT questsCompleted FROM user WHERE username = ?", (user,))
    questsCompleted_string = c.fetchone()[0]
    db.commit()
    db.close()
    if questsCompleted_string == '':
        return []
    return questsCompleted_string.split('&')

# return list of quests active for the logged in user
def questsActive_list(user):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT questsActive FROM user WHERE username = ?", (user,))
    questsActive_string = c.fetchone()[0]
    db.commit()
    db.close()
    if questsActive_string == '':
        return []
    return questsActive_string.split('&')

# return boolean (true if less than 3 active quests)
def questsAvailable(user):
    if len(questsActive_list(user)) == 3:
        return False
    return True

# return string describing status of quest given npc name
def npc_questStatus(npc_name, user):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()
    c.execute("SELECT questName FROM npc WHERE name = ?", (npc_name,))
    quest_name = c.fetchone()[0]
    db.commit()
    db.close()
    if quest_name in questsActive_list(user):
        return 'quest_in_progress'
    elif quest_name[0] in questsCompleted_list(user):
        return 'quest_completed'
    return 'quest_inactive'

# return string describing status of quest given npc name
def add_quest(npc_name, user):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()

    questsActive = questsActive_list(user)

    c.execute("SELECT questName FROM npc WHERE name = ?", (npc_name,))
    quest_name = c.fetchone()[0]

    questsActive.append(quest_name)
    new_quests_active = "&".join(questsActive)
    c.execute("UPDATE user SET questsActive = ? WHERE username = ?", (new_quests_active, user))

    db.commit()
    db.close()

def get_quests(npcs):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()

    quests = {}

    for npc in npcs:
        c.execute("SELECT questName, questType, questDesc, questReq, questRequiredAmount FROM npc WHERE name = ?", (npc,))
        quest_info = c.fetchone()
        quests[npc] = {
            'name': quest_info[0],
            'type': quest_info[1],
            'desc': quest_info[2],
            'fulfillment_requirement': quest_info[3],
            'amount_required': quest_info[4]
        }

    db.commit()
    db.close()

    return quests

def complete_quest(npc, user):
    db = sqlite3.connect(DB_FILE)
    c = db.cursor()

    c.execute("SELECT questName FROM npc WHERE name = ?", (npc,))
    quest = c.fetchone()[0]

    c.execute("SELECT questsActive FROM user WHERE username = ?", (user,))
    questsActive = c.fetchone()[0]

    c.execute("SELECT questsCompleted FROM user WHERE username = ?", (user,))
    questsCompleted = c.fetchone()[0]

    new_quests_active = questsActive.replace(f"&{quest}", '')
    c.execute("UPDATE user SET questsActive = ? WHERE username = ?", (new_quests_active, user))
    c.execute("UPDATE user SET questsCompleted = ? WHERE username = ?", (questsCompleted + f"&{quest}", user))

    db.commit()
    db.close()

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

    curr_removals = 0
    itemslist = list(items)
    while item_name in itemslist:
        index = itemslist.index(item_name)

        sql_index = index + 1 + curr_removals
        c.execute(f"SELECT item{sql_index}Count FROM user WHERE username = ?", (username,))
        current_item_count = c.fetchone()[0]

        c.execute("SELECT maxCount FROM item WHERE name = ?", (item_name,))
        max_item_count = c.fetchone()[0]

        if current_item_count + item_number <= max_item_count:
            c.execute(f"UPDATE user SET item{sql_index}Count = ? WHERE username = ?", (current_item_count + item_number, username))
            db.commit()
            db.close()
            return True
        else:
            itemslist.pop(index)
            curr_removals += 1

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
            c.execute("INSERT into user VALUES (?, ?, 100, 100, '', '', '', '', '', '', 0, 0, 0, 0, 0, 0, '', '', FALSE)", (username, password))
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
            user = body.get('user')
            quest_status = npc_questStatus(npc, user)

            return jsonify( {
                'dialogue': npc_dialogue[npc],
                'quest_status': quest_status
            })

        if body.get('type') == 'fetch_quests':
            npcs = body.get('npcs')
            quests = get_quests(npcs)

            return jsonify( { 'quests': quests })

        if body.get('type') == 'add_quest':
            npc = body.get('npc')
            user = body.get('user')
            add_quest(npc, user)

            return jsonify( { 'request': 'handled' })

        if body.get('type') == 'complete_quest':
            npc = body.get('npc')
            user = body.get('user')
            complete_quest(npc, user)

            return jsonify( { 'request': 'handled' })

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
