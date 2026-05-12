# Cindy and Her 3 Goons’ Design Doc
### __P05__ – _Le Fin_

### PROJECT NAME: _Snorphan_ 
TARGET SHIP DATE: 2026-06-01

<br>

## _ROSTER_
| Name | Email | Primary Role | Secondary Role |
| ---- | ----- | ------------ | -------------- |
| Carrie Ko | carriek3@nycstudents.net | PM | Mediator |
| Cindy Liu | cindyl125@nycstudents.net | Devo | Physics and Movement |
| Joyce Lin | joycel78@nycstudents.net | Devo | Interactions |
| Jeff Ou | jiefengo@nycstudents.net | Devo | Server Handling |

<br>

## ___PROJECT SUMMARY___
> __Snorphan is an open world puzzle-adventure game. You're a lonely orphan who has no friends and in order to cure your insatiable loneliness, you spend your life building snowmen. But, oh no! Your snowmen are all sad and naked! Thus, as a last resort, you finally decide to socialize and look to the town's villagers for help. And boy do they have some work for you to do.__

### _Problem Being Solved_
We are bringing awareness to the loneliness of orphans and snowmen.

### _Target Users_
* Orphan lovers
* Snowmen lovers

### _Why This Project Matters_
This is a very real issue in the real world. Orphanages have low adoption rates and [orphans who get left behind](https://en.wikipedia.org/wiki/The_Three_Stooges_(2012_film)) lose their most important human connections. This game is meant to give awareness to the love that orphans deserve.

<br>

## _MINIMUM VIABLE PRODUCT (MVP) SCOPE_
### Core Features
We will have a working story game with an orphan character that can make snowmen, obtain items, and interact with NPCs (dialogue, quests, etc). There will be a fixed terrain and map.

### Stretch Features
1) Using the Godot game engine to create a 3D game (if PR gets green lit).
2) Using items (ie. throwing snowballs, using a shovel, etc.).
3) Fighting a boss.

### Explicit Non-Goals
Features intentionally **excluded**  
* Fight your snowmen  
* Selecting different base characters  

<br>

## TECHNOLOGY STACK
| Layer | Selected Tool |
| ----- | ------------- |
| Backend Framework | Node.js |
| Frontend Framework | none |
| Database | SQLite |
| Authentication | Node Sessions |
| ORM / DB Library | none |

### Why This Stack Was Chosen
* `Backend Framework`: Node allows for easy set up of WebSocket servers as it supports it natively as opposed to Flask. This makes it more convenient when attempting to set up multiplayer features (though main story quests are player specific)!
* `Frontend Framework`: We will not be utilizing a Frontend Framework as we prefer manually doing CSS :D
* `Database`: As most members of our group are more accustomed to SQLite and there is no particular reason why we would need document-oriented databasing
* `Authentication`: Node supports sessions which is what we will be using to set up our authentication system!!

<br>

## TEAM OWNERSHIP PLAN
_Each member must own meaningful deliverables_

| Team Member | Primary Ownership | Secondary Ownership | Specific Deliverables |
| ----------- | ----------------- | ------------------- | --------------------- |
| Carrie Ko | Visuals | Backend Development | Character models, SQLite3 databases, Story Quests |
| Cindy Liu | Backend Development | Visuals | Authentication system, Movement system |
| Joyce Lin | Visuals | Backend Development | Map/terrain, Model rigging, Story Quests |
| Jeff Ou | Backend Development | Visuals | Node WebSocket Server, Multiplayer connections |

<br>

## Program Components + Explanation
<ins>_Backend_</ins>
- `SQLITE`: db storage for all our storage needs

<ins>_HTML (frontend display)_</ins>
- `start.html`: startscreen for all your starts
- `login.html`: you can login as a user wow amazing 10/10
- `register.html`: wow you can register up and actually play our game wow amazing 11/10
- `index.html`: contains exported Godot app and allows for embedding
- `game.html`: this is where our game will live and where we will serve it for you to see

<ins>_Javascript_</ins>
- `server.js`: node setup code

<br>

## Component Map
[![](https://mermaid.ink/img/pako:eNptkk1PwzAMhv9K5HOpaNa1W4WQ2MrGhROcaHcIq9cWNc2UDxhs---4GUNDIqf49ePXdpQ9rFWFkMGmUx_rRmjLnvOyZ3TuCoP6HXX4Zlbs6ur24ENzYLOiU3Xbh42V3Yr9wJ7Yuq4zbKOVPLCHohJWvAqDZnXJnF3mhca6NZYaeKMTM2M3BLE5-68kL2oh8RL_m18WxtIGl8ByANjsFMw9vdYoLDJHVWR5bjtkhLPNXz33OspXrMj_vmj7CneX_vce0K43TPUHtiiW-dNat1vLFm33u_nJhl5NOUtj0nKDDgHUuq0gs9phABK1FEMI-yFbgm1QYgkZXSvcCNfZEsr-SGVb0b8oJc-VWrm6gWwjOkOR29LDY96KWgv5q2qk0fVcud5CFo3SiXeBbA87yHgaheM4jibTeDyK-DiAT4LicJrwdMxHMec8jnh0DODLt70OJ8k1SVESpUkyTTkPAKvWKv14-k3-Ux2_Aa-1u2g?type=png)](https://mermaid.live/edit#pako:eNptkk1PwzAMhv9K5HOpaNa1W4WQ2MrGhROcaHcIq9cWNc2UDxhs---4GUNDIqf49ePXdpQ9rFWFkMGmUx_rRmjLnvOyZ3TuCoP6HXX4Zlbs6ur24ENzYLOiU3Xbh42V3Yr9wJ7Yuq4zbKOVPLCHohJWvAqDZnXJnF3mhca6NZYaeKMTM2M3BLE5-68kL2oh8RL_m18WxtIGl8ByANjsFMw9vdYoLDJHVWR5bjtkhLPNXz33OspXrMj_vmj7CneX_vce0K43TPUHtiiW-dNat1vLFm33u_nJhl5NOUtj0nKDDgHUuq0gs9phABK1FEMI-yFbgm1QYgkZXSvcCNfZEsr-SGVb0b8oJc-VWrm6gWwjOkOR29LDY96KWgv5q2qk0fVcud5CFo3SiXeBbA87yHgaheM4jibTeDyK-DiAT4LicJrwdMxHMec8jnh0DODLt70OJ8k1SVESpUkyTTkPAKvWKv14-k3-Ux2_Aa-1u2g)

**Note**: GDScript files are Godot-specific files that allows interactions and events within the app to occur. Javascript within Index.html contains the exported engine object which allows the app to run. GDScript files are only relevant within Godot itself but since Index.html is rendering the app itself, it technically runs on these script files as well.

<br>

## Site Map (front end)
[![](https://mermaid.ink/img/pako:eNpVUMtqwzAQ_BWzJxccY1l2lIhQSOwee-up-CKi9QMsKcgSfZj8e2UbQrqnnZmdGdgZrkYicGhH83XthXXRR93oKMw5nlzAae_U-BLtdq_RJR5NN-iN2Y4u0WlRqthiN0wO7X9x0eq4Ewqf-WrjN1Cv4G2JNv657QwJdHaQwFsxTpiAQqvEgmFerA24HhU2wMMqsRV-dA00-h58N6E_jVHAnfXBaY3v-keOv0nhsB5EZ4V6sBa1RFsZrx1wUrI1BPgM38ApO6TH4khJRrOc0aJI4Gc5Ssm-ZIQGPi8Iuyfwu5Zm6Z7l5SFMQcs8y0qSAMrBGfu-PXv9-f0PdoBvvg?type=png)](https://mermaid.live/edit#pako:eNpVUMtqwzAQ_BWzJxccY1l2lIhQSOwee-up-CKi9QMsKcgSfZj8e2UbQrqnnZmdGdgZrkYicGhH83XthXXRR93oKMw5nlzAae_U-BLtdq_RJR5NN-iN2Y4u0WlRqthiN0wO7X9x0eq4Ewqf-WrjN1Cv4G2JNv657QwJdHaQwFsxTpiAQqvEgmFerA24HhU2wMMqsRV-dA00-h58N6E_jVHAnfXBaY3v-keOv0nhsB5EZ4V6sBa1RFsZrx1wUrI1BPgM38ApO6TH4khJRrOc0aJI4Gc5Ssm-ZIQGPi8Iuyfwu5Zm6Z7l5SFMQcs8y0qSAMrBGfu-PXv9-f0PdoBvvg)

<br>

## Key User Stories
### Orphano McLover
As an orphan lover, I want to be able to properly experience life as an orphan making snowmen so that I can understand the life and mindset of orphans better.

### Snowmin Loverman
As a snowman lover, I want to be able to make lots of snowmen so that I can satisfy my cravings for snowmen even when it isn't winter.

<br>

## Database Organization
### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _USER_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------| ------------------------- |
| TEXT | username | PK |
| TEXT | password | NOT NULL |
| INTEGER | hp | NOT NULL |
| INTEGER | stamina | NOT NULL |
| TEXT | item1 | FK |
| TEXT | item2 | FK |
| TEXT | item3 | FK |
| TEXT | item4 | FK |
| TEXT | item5 | FK |
| TEXT | item6 | FK |
| INTEGER | item1Count |    |
| INTEGER | item2Count |    |
| INTEGER | item3Count |    |
| INTEGER | item4Count |    |
| INTEGER | item5Count |    |
| INTEGER | item6Count |    |

<br>

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_ITEM_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------|-------------------------- |
| TEXT | name | PK |
| TEXT | desc | NOT NULL |
| TEXT | image | NOT NULL |
| INTEGER | maxCount | NOT NULL |
| BOOLEAN | hasBeenFound | NOT NULL |  

_hasBeenFound will help monitor whether an item is unlocked in encyclopedia and whether a pop up will occur when item is acquired for the first time_

<br> 

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_NPC_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------|-------------------------- |
| TEXT | name | PK |
| TEXT | dialogue | NOT NULL |
| TEXT | completedQuestUsers |   |

* Dialogue EX. ~ "DG1$A.OPTION1$B.OPTION2&A.DG2...&B.DG2..."
  * Dialogues will be split with & while the options themselves are split with $ (arr[0] will always point to the printed dialogue)
  * Each line of dialogue will be preceded by the letter corresponding to each possible option
* completedQuestUsers EX. ~ "USER1$USER2$USER3$USER4"
  * Used to check if user has completed the quest!

<br>

## _TESTING PLAN_
Upon completion of each game component (assignation of story quests, NPC interactions, snowman rolling, etc.), they will be tested through gameplay as well as
cheats designated for debugging. Any associated features will not be worked on until the basic component is working!

Components such as backend server handling will be debugged as it always has been, through debug statements and pair handling.

<br>

## TIMELINE
### WEEK 1:
* Inserted models and animations (* Models will be acquired through the internet but rigging will be done through blender)
* Working movement system
* Terrain created
* Server connections and multiplayer set up
* Exit to startscreen and log-out system
* Inventory system

### WEEK 2:
* Snowman creation system 
* NPC interaction (dialogue system) 
* Cave systems created (with purpose!)
* Puzzles set up and planned out
* Itsm usage system
* Item encyclopedia

### WEEK 3:
* Story quest system set up
* Cross player interaction (snowball throwing)
* Puzzles all implemented
* Final boss/disaster sequence implemented

### INTERNAL DEADLINES:
1) `Working movement system` ~ 5/12 
2) `Working node websocket server up on primary domain` ~ 5/12
3) `multiplayer system connections` ~ 5/13
4) `inventory system` ~ 5/15
5) `character models and map` ~ 5/15
6) `dialogue system` ~ 5/19
7) `puzzles set up` ~ 5/20
8) `snowman creation system` ~ 5/22
9) `item usage system and encyclopedia` ~ 5/22
10) `story quests set up` ~ 5/26
11) `puzzles all implemented` ~ 5/28
12) `cross player interaction` ~ 5/29
13) `final boss/disaster completion` ~ 5/31

<br>

## _COMPLETION CRITERIA_ 
Project is considered complete when all of the following are true:
1) the app runs without crashing, ever
2) start/login/register routes into the game, somehow, in reasonable order
3) promised snowman functionality exists and works
4) all assets load in on the average runthrough
5) you cannot get stuck in-game (bugged progression, model stuck underground, etc.) w/o logout/restart available

<br>

## _OPEN QUESTIONS_
Will the final challenge be a boss fight (big yeti or snowman?!) or will it be an escape sequence (avalanche, collapsing cave, etc)?

## _APPENDIX_
As Godot has yet to be greenlit, any Godot-reliant systems are subject to change. In the case that Godot will be rejected, the game will
pivot towards a 2D system where characters move across a static page. Most components will remain the same otherwise.
