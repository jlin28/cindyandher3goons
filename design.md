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
[![](https://mermaid.ink/img/pako:eNptkk1PwzAMhv9K5HOpaNa1W4WQ2MrGhROcaHcIq9cWNc2UDxhs---4GUNDIqf49ePXdpQ9rFWFkMGmUx_rRmjLnvOyZ3TuCoP6HXX4Zlbs6ur24ENzYLOiU3Xbh42V3Yr9wJ7Yuq4zbKOVPLCHohJWvAqDZnXJnF3mhca6NZYaeKMTM2M3BLE5-68kL2oh8RL_m18WxtIGl8ByANjsFMw9vdYoLDJHVWR5bjtkhLPNXz33OspXrMj_vmj7CneX_vce0K43TPUHtiiW-dNat1vLFm33u_nJhl5NOUtj0nKDDgHUuq0gs9phABK1FEMI-yFbgm1QYgkZXSvcCNfZEsr-SGVb0b8oJc-VWrm6gWwjOkOR29LDY96KWgv5q2qk0fVcud5CFo3SiXeBbA87yHgaheM4jibTeDyK-DiAT4LicJrwdMxHMec8jnh0DODLt70OJ8k1SVESpUkyTTkPAKvWKv14-k3-Ux2_Aa-1u2g?type=png)](https://mermaid.live/edit#pako:eNptkk1PwzAMhv9K5HOpaNa1W4WQ2MrGhROcaHcIq9cWNc2UDxhs---4GUNDIqf49ePXdpQ9rFWFkMGmUx_rRmjLnvOyZ3TuCoP6HXX4Zlbs6ur24ENzYLOiU3Xbh42V3Yr9wJ7Yuq4zbKOVPLCHohJWvAqDZnXJnF3mhca6NZYaeKMTM2M3BLE5-68kL2oh8RL_m18WxtIGl8ByANjsFMw9vdYoLDJHVWR5bjtkhLPNXz33OspXrMj_vmj7CneX_vce0K43TPUHtiiW-dNat1vLFm33u_nJhl5NOUtj0nKDDgHUuq0gs9phABK1FEMI-yFbgm1QYgkZXSvcCNfZEsr-SGVb0b8oJc-VWrm6gWwjOkOR29LDY96KWgv5q2qk0fVcud5CFo3SiXeBbA87yHgaheM4jibTeDyK-DiAT4LicJrwdMxHMec8jnh0DODLt70OJ8k1SVESpUkyTTkPAKvWKv14-k3-Ux2_Aa-1u2g)


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

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_ITEM_

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

<br>

## Site Map (front end)
[![](https://mermaid.ink/img/pako:eNpVUMtqwzAQ_BWzJxccY1l2lIhQSOwee-up-CKi9QMsKcgSfZj8e2UbQrqnnZmdGdgZrkYicGhH83XthXXRR93oKMw5nlzAae_U-BLtdq_RJR5NN-iN2Y4u0WlRqthiN0wO7X9x0eq4Ewqf-WrjN1Cv4G2JNv657QwJdHaQwFsxTpiAQqvEgmFerA24HhU2wMMqsRV-dA00-h58N6E_jVHAnfXBaY3v-keOv0nhsB5EZ4V6sBa1RFsZrx1wUrI1BPgM38ApO6TH4khJRrOc0aJI4Gc5Ssm-ZIQGPi8Iuyfwu5Zm6Z7l5SFMQcs8y0qSAMrBGfu-PXv9-f0PdoBvvg?type=png)](https://mermaid.live/edit#pako:eNpVUMtqwzAQ_BWzJxccY1l2lIhQSOwee-up-CKi9QMsKcgSfZj8e2UbQrqnnZmdGdgZrkYicGhH83XthXXRR93oKMw5nlzAae_U-BLtdq_RJR5NN-iN2Y4u0WlRqthiN0wO7X9x0eq4Ewqf-WrjN1Cv4G2JNv657QwJdHaQwFsxTpiAQqvEgmFerA24HhU2wMMqsRV-dA00-h58N6E_jVHAnfXBaY3v-keOv0nhsB5EZ4V6sBa1RFsZrx1wUrI1BPgM38ApO6TH4khJRrOc0aJI4Gc5Ssm-ZIQGPi8Iuyfwu5Zm6Z7l5SFMQcs8y0qSAMrBGfu-PXv9-f0PdoBvvg)

## Member Tasks/Roles

| TASK | DEVO | EXPECTED COMPLETION DATE |
|------|------|--------------------------|
| temp | temp | temp |

