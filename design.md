# Cindy and Her 3 Goons’ Design Doc for P05 – Le Fin  
⤷ _Roster:_ $${\color{red}Carrie \space Ko \space (PM)}$$, $${\color{yellow}Joyce \space Lin}$$, $${\color{green}Cindy \space Liu}$$, $${\color{blue}Jeff \space Ou}$$   
TARGET SHIP DATE: TBA   

### PROJECT NAME: _bleh_ 

<br>

<ins>___PROJECT DESCRIPTION___</ins>   
> __bleh is an open world puzzle-adventure game. You're a lonely orphan who has no friends and in order to cure your insatiable loneliness, you spend your life building snowmen. But, oh no! Your snowmen are all sad and naked! Thus, as a last resort, you finally decide to socialize and look to the town's villagers for help. And boy do they have some work for you to do. 😰__

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

## Component Map
[![](https://mermaid.ink/img/pako:eNptkstuwjAQRX_FmnWIcEh4RFWlkgDddNWumrAwyeRRxTHyo6UF_r3GQAVSvfLcOXPHY80eClEixFB14qtomNTkLc17Ys9TplB-ovQ_1JoMBo8HF6oDmWedqNvebzTv1uQCO2Jruk6RSgp-IM9ZyTTbMIVqfctcXZJMYt0qbRs4ozMzJw8WIgn5ryTNasbxFr_PrzKl7QS3wOoEkPk5SBxdSGQaibFV1vLa9pRhRjf3eup05Bssrf8ia_sSd7f-CwdI0ysi-gNZZqv0tZDtVpNl210mBw9q2ZYQa2nQA46Ss1MI-1M2B90gxxxiey2xYqbTOeT90ZZtWf8uBL9WSmHqBuKKdcpGZms_GNOW1ZLxP1WifaJMhOk1xDQYhc4F4j3sIA4m1I_CkE5nYTSiQeTBt4VCfzYOJpFlgyAIaUCPHvy4tkN_Oh5aiY4ndDqJ6Ix6gGWrhXw5b41bnuMvb8-0NQ?type=png)](https://mermaid.live/edit#pako:eNptkstuwjAQRX_FmnWIcEh4RFWlkgDddNWumrAwyeRRxTHyo6UF_r3GQAVSvfLcOXPHY80eClEixFB14qtomNTkLc17Ys9TplB-ovQ_1JoMBo8HF6oDmWedqNvebzTv1uQCO2Jruk6RSgp-IM9ZyTTbMIVqfctcXZJMYt0qbRs4ozMzJw8WIgn5ryTNasbxFr_PrzKl7QS3wOoEkPk5SBxdSGQaibFV1vLa9pRhRjf3eup05Bssrf8ia_sSd7f-CwdI0ysi-gNZZqv0tZDtVpNl210mBw9q2ZYQa2nQA46Ss1MI-1M2B90gxxxiey2xYqbTOeT90ZZtWf8uBL9WSmHqBuKKdcpGZms_GNOW1ZLxP1WifaJMhOk1xDQYhc4F4j3sIA4m1I_CkE5nYTSiQeTBt4VCfzYOJpFlgyAIaUCPHvy4tkN_Oh5aiY4ndDqJ6Ix6gGWrhXw5b41bnuMvb8-0NQ)


## Database Organization
### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _USER_

| TYPE | VALUE | ADDITIONAL SPECIFICATIONS |
|------|-------| ------------------------- |
| TEXT | username | PK |
| TEXT | password | NOT NULL |
| INTEGER | hp | NOT NULL |
| INTEGER | stamina | NOT NULL |
| INTEGER | snowballs | NOT NULL |
| TEXT | item1 | FK |
| TEXT | item2 | FK |
| TEXT | item3 | FK |
| TEXT | item4 | FK |
| TEXT | item5 | FK |
| TEXT | item6 | FK |  

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
[![](https://mermaid.ink/img/pako:eNpVUEtrhDAQ_isyJwuuJNqsblgKu3rtrafiJWzGKJhkiZFtK_73RoU-5jTzvQa-GW5WInBoB_u4dcL56K1uTBTmEo8-3Gnn9fAUHQ4v0TUerOrNjuyia3RemSp2qPrRo_tPrlwdK6HxL17tOCSgXC-Bt2IYMQGNTov1hnnVNeA71NgAD6vEVkyDb6AxS_DdhXm3VgP3bgpOZyfV_eRMdyk81r1QTvxK0Eh0lZ2MB06PWwTwGT6AM0JTespKSggr2SkvWAKfAS5SmpGcMsZowYqSLgl8bU9Jegy6MmckC2T2nAcDyt5b97qXuXW6fAPiiWcg?type=png)](https://mermaid.live/edit#pako:eNpVUEtrhDAQ_isyJwuuJNqsblgKu3rtrafiJWzGKJhkiZFtK_73RoU-5jTzvQa-GW5WInBoB_u4dcL56K1uTBTmEo8-3Gnn9fAUHQ4v0TUerOrNjuyia3RemSp2qPrRo_tPrlwdK6HxL17tOCSgXC-Bt2IYMQGNTov1hnnVNeA71NgAD6vEVkyDb6AxS_DdhXm3VgP3bgpOZyfV_eRMdyk81r1QTvxK0Eh0lZ2MB06PWwTwGT6AM0JTespKSggr2SkvWAKfAS5SmpGcMsZowYqSLgl8bU9Jegy6MmckC2T2nAcDyt5b97qXuXW6fAPiiWcg)

## Member Tasks/Roles

| TASK | DEVO | EXPECTED COMPLETION DATE |
|------|------|--------------------------|
| temp | temp | temp |

