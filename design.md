# Cindy and Her 3 Goons’ Design Doc for P05 – Le Fin  
⤷ _Roster:_ $${\color{red}Carrie \space Ko}$$ (PM), $${\color{yellow}Joyce \space Lin}$$, $${\color{green}Cindy \space Liu}$$, $${\color{blue}Jeff \space Ou}$$   
TARGET SHIP DATE: TBA   

### PROJECT NAME: _bleh_ 

<br>

<ins>___PROJECT DESCRIPTION___</ins>   
> __bleh is an open world puzzle-adventure game. You're a lonely orphan who has no friends and in order to cure your insatiable loneliness you spend your life building snowmen.__

## Program Components + Explanation
_HTML (frontend display)_
- login.html
- register.html
- game.html

_Javascript_
- server.js

## Component Map


## Database Organization
### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _USER_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------| ------------------------- |
| TEXT | username | PK |
| TEXT | password | NOT NULL |
| INTEGER | hp | NOT NULL |
| INTEGER | stamina | NOT NULL |
| INTEGER | snowballs | NOT NULL |
| BOOLEAN | item1 | FK |
| BOOLEAN | item2 | FK |
| BOOLEAN | item3 | FK |
| BOOLEAN | item4 | FK |
| BOOLEAN | item5 | FK |
| BOOLEAN | item6 | FK |  

<br>

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_ITEM_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------|-------------------------- |
| TEXT | name | PK |
| TEXT | desc | NOT NULL |
| TEXT | image | NOT NULL |

<br> 

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_NPC_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------|-------------------------- |
| TEXT | name | PK |
| TEXT | dialogue | NOT NULL |

<br>

## Site Map (front end)


## Member Tasks/Roles

| TASK | DEVO | EXPECTED COMPLETION DATE |
|------|------|--------------------------|
| temp | temp | temp |
