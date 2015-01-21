import processing.serial.*;
import ddf.minim.*;

int previousMillis = 0;

/////////////
// Arduino //
/////////////
Serial myPort;
String stringReceived;
String stringToSend;
String[] moves;
boolean hasWaited = false;

//////////
// Game //
//////////
Game game;
Minim minim;//audio context

////////////
// Screen //
////////////
int screenWidth  = 1680;
int screenHeight = 1050;

//////////
// Pong //
//////////
int level;
Pong pongLeft;
Pong pongRight;
Pong pongTop;
Pong pongBottom;
Pong pongDiagonalTLBR;
Pong pongDiagonalTRBL;
Pong pongFull;

////////////
// Player //
////////////
int playersNumber = 4;
ArrayList<Player> players = new ArrayList<Player>();
// Temporaire
int playerTopLeft;
int playerTopRight;

///////////
// Score //
///////////
Score scorePlayerTop;
Score scorePlayerBottom;
int scorePlayer = 0;
// Score Top
int scorePosYTop = screenHeight / 4 + 50;
// Score Bottom
int scorePosYBottom = screenHeight - (screenHeight / 4 - 50);

///////////
// Simon //
///////////
Simon simon;
int numberOfLed = 4;
int numberOfColorInSequence = 3;
// SimonResolver
// SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;
 // /!\ cette variable doit être celle du joueur et récupérée pour chaque joueur. N'apparaît pas dans le main.

///////////////////
// fightLauncher //
///////////////////
int interval = 5;
int pauseInterval = 300;
FightLauncher fightLauncherBottom;
boolean launcherNeedTowait = false;
String currentTimer;
boolean pongCanBeLaunched = true;

void setup()
{
    ///////////////////
    // fightLauncher //
    ///////////////////
    fightLauncherBottom = new FightLauncher("3",5,scorePosYBottom);

    //////////
    // Game //
    //////////
    minim = new Minim(this);
    game = new Game(minim);
    game.backgroundSound.player.play();

    /////////////
    // Arduino //
    /////////////
    instantiateArduino();

    ////////////
    // Screen //
    ////////////
    size(screenWidth, screenHeight);

    ///////////
    // Simon //
    ///////////
    simon = new Simon(numberOfColorInSequence, numberOfLed);
    // simonResolver = new SimonResolver(simon.sequenceToPlay);

    ////////////
    // Player //
    ////////////
    for (int i = 0; i < playersNumber; i++) {
        players.add(new Player(minim, i, simon.sequenceToPlay));
    }

    ///////////
    // Score //
    ///////////
    //scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    //scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    //////////
    // Pong //
    //////////
        level = 1;

        /////////////
        // Level 1 //
        /////////////
        pongLeft = new Pong(game, screenWidth/2, screenHeight, 0, 0, color(41, 118, 174), players, 0);
        pongRight = new Pong(game, screenWidth/2, screenHeight, screenWidth/2, 0, color(238, 148, 39), players, 1);

        /////////////
        // Level 2 //
        /////////////
        pongTop = new Pong(game, screenWidth, screenHeight/2, 0, 0, color(41, 118, 174), players, 2);
        pongBottom = new Pong(game, screenWidth, screenHeight/2, 0, screenHeight/2, color(238, 148, 39), players, 3);

        /////////////
        // Level 3 //
        /////////////
        pongDiagonalTLBR = new Pong(game, screenWidth, screenHeight, 0, 0, color(221), players, 4);
        pongDiagonalTRBL = new Pong(game, screenWidth, screenHeight, 0, 0, color(221), players, 5);

        /////////////
        // Level 4 //
        /////////////
        pongFull = new Pong(game, screenWidth, screenHeight, 0, 0, color(169, 76, 79), players, 6);

    //simon.play();

    if (game.activeScreen == 0) {
        game.drawInitialScreen();
    }
}

void draw()
{
    int currentMillis = millis();

    if (game.activeScreen != 0) {
        //////////
        // Pong //
        //////////
        switch (level) {
            case 1 :
                /////////////
                // Level 1 //
                /////////////
                pongLeft.draw();
                pongRight.draw();
                break;
            case 2 :
                /////////////
                // Level 2 //
                /////////////
                pongTop.draw();
                pongBottom.draw();
                break;
            case 3 :
                /////////////
                // Level 3 //
                /////////////
                pongDiagonalTLBR.draw();
                pongDiagonalTRBL.draw();
                break;
            default :
                /////////////
                // Level 4 //
                /////////////
                pongFull.draw();
                break;
        }


        fightLauncherBottom.draw();
        displayLauncher(currentMillis);

        // if(pongCanBeLaunched) {
        //     pongTop.draw();
        //     pongBottom.draw();
        // }

    }

    ///////////
    // Score //
    ///////////
    //scorePlayerTop.displayScore();
    //scorePlayerBottom.displayScore();

    /////////////
    // Arduino //
    /////////////
    readArduino();
    readKeyboard();
}

void instantiateArduino()
{
    String portName = Serial.list()[3];
    myPort = new Serial(this, portName, 9600);
}

void readArduino()
{
    if(!hasWaited){
        hasWaited = true;
        delay(1000);
        simon.play();
        sendStringToArduino();
    }

    if(myPort.available() > 0){
        stringReceived = myPort.readStringUntil('\n');
        if(stringReceived != null) {
            //println("stringReceived: "+stringReceived);
            moves = split(stringReceived,'$');
            if (mousePressed == true) {
                sendStringToArduino();
            }

            if(moves.length == 4){
                // joueur top left
                switch (int(moves[2].trim())) {
                    case 0 :
                        players.get(0).returnedValueByResolver = players.get(0).resolver.compareSolution(0);
                        break;
                    case 1 :
                        players.get(0).returnedValueByResolver = players.get(0).resolver.compareSolution(1);
                        break;
                    case 2 :
                        players.get(0).returnedValueByResolver = players.get(0).resolver.compareSolution(2);
                        break;
                    case 3 :
                        players.get(0).returnedValueByResolver = players.get(0).resolver.compareSolution(3);
                        break;
                }
                // joueur top right
                switch (int(moves[3].trim())) {
                    case 0 :
                        players.get(1).returnedValueByResolver = players.get(1).resolver.compareSolution(0);
                        break;
                    case 1 :
                        players.get(1).returnedValueByResolver = players.get(1).resolver.compareSolution(1);
                        break;
                    case 2 :
                        players.get(1).returnedValueByResolver = players.get(1).resolver.compareSolution(2);
                        break;
                    case 3 :
                        players.get(1).returnedValueByResolver = players.get(1).resolver.compareSolution(3);
                        break;
                }

                // if(returnedValueByResolver == 2) {
                //     resetSimon();
                // }
                for (int i = 0; i < playersNumber; i++) {
                    if(players.get(i).returnedValueByResolver == 2) {
                        resetSimon(i);
                    }
                }

                playerTopLeft = int(moves[1].trim());
                playerTopRight = int(moves[0].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                players.get(0).bar.posX = playerTopLeft*(screenWidth/2-players.get(0).bar.width)/255;
                players.get(1).bar.posX = playerTopRight*(screenWidth/2-players.get(1).bar.width)/255 + screenWidth/2;
            }
        }
    }
}

void sendStringToArduino()
{
    stringToSend = str(numberOfColorInSequence);
    for(int i = 0; i < numberOfColorInSequence; i++) {
        stringToSend += "$"+str(simon.sequenceToPlay.get(i));
    }
    stringToSend += "\n";
    myPort.write(stringToSend);
}

void resetSimon(int player)
{
    for (int i = 0; i < playersNumber; i++) {
        players.get(i).returnedValueByResolver = 0;
    }
    simon.win(player);
    simon = new Simon(++numberOfColorInSequence,numberOfLed);
    for (int i = 0; i < playersNumber; i++) {
        players.get(i).resolver = new SimonResolver(simon.sequenceToPlay);
    }
    simon.play();
    sendStringToArduino();
}

void readKeyboard()
{
    if (keyPressed) {
        if (key == CODED) {
            // Controls for top left bar
            if (keyCode == LEFT) {
                if (!players.get(0).bar.controlInverted && players.get(0).bar.posX > 0) {
                    players.get(0).bar.posX -= 5;
                }
                else if (players.get(0).bar.controlInverted && players.get(0).bar.posX < screenWidth / 2 - players.get(0).bar.width) {
                    players.get(0).bar.posX += 5;
                }
             }
            else if (keyCode == RIGHT) {
                if (!players.get(0).bar.controlInverted && players.get(0).bar.posX < screenWidth / 2 - players.get(0).bar.width) {
                    players.get(0).bar.posX += 5;
                }
                else if (players.get(0).bar.controlInverted && players.get(0).bar.posX > 0) {
                    players.get(0).bar.posX -= 5;
                }
            }
        }
        else {
            if (key == ENTER) {
                game.activeScreen = 1;
            }
            // Controls for bottom left bar
            if (key == 'q' || key == 'Q') {
                if (!players.get(2).bar.controlInverted && players.get(2).bar.posX > 0) {
                    players.get(2).bar.posX -= 5;
                }
                else if (players.get(2).bar.controlInverted && players.get(2).bar.posX < screenWidth / 2 - players.get(2).bar.width) {
                    players.get(2).bar.posX += 5;
                }
             }
             else if ((key == 's' || key == 'S')) {
                if (!players.get(2).bar.controlInverted && players.get(2).bar.posX < screenWidth / 2 - players.get(2).bar.width) {
                     players.get(2).bar.posX += 5;
                }
                else if (players.get(2).bar.controlInverted && players.get(2).bar.posX > 0) {
                    players.get(2).bar.posX -= 5;
                }
             }
             // Controls for right left bar
            else if (key == 'a' || key == 'A') {
                if (!players.get(1).bar.controlInverted && players.get(1).bar.posX > screenWidth / 2) {
                    players.get(1).bar.posX -= 5;
                }
                else if (players.get(1).bar.controlInverted && players.get(1).bar.posX < screenWidth - players.get(1).bar.width) {
                    players.get(1).bar.posX += 5;
                }
             }
             // Controls for bottom right bar
            else if ((key == 'z' || key == 'Z')) {
                if (!players.get(1).bar.controlInverted && players.get(1).bar.posX < screenWidth - players.get(1).bar.width) {
                    players.get(1).bar.posX += 5;
                }
                else if (players.get(1).bar.controlInverted && players.get(1).bar.posX > screenWidth / 2) {
                    players.get(1).bar.posX -= 5;
                }
            }
            else if (key == 'w' || key == 'W') {
                if (!players.get(3).bar.controlInverted && players.get(3).bar.posX > screenWidth / 2) {
                    players.get(3).bar.posX -= 5;
                }
                else if (players.get(3).bar.controlInverted && players.get(3).bar.posX < screenWidth - players.get(3).bar.width) {
                    players.get(3).bar.posX += 5;
                }
            }
            else if ((key == 'x' || key == 'X')) {
                if (!players.get(3).bar.controlInverted && players.get(3).bar.posX < screenWidth - players.get(3).bar.width) {
                    players.get(3).bar.posX += 5;
                }
                else if (players.get(3).bar.controlInverted && players.get(3).bar.posX > screenWidth / 2) {
                    players.get(3).bar.posX -= 5;
                }
            }
            else if (key == 'e' || key == 'E') {
                players.get(0).bar.expand();
            }
            else if (key == 'r' || key == 'R') {
                players.get(0).bar.shrink();
            }
            else if (key == 'i' || key == 'I') {
                pongLeft.ball.transparentMalus = true;
                pongLeft.ball.isTransparent = true;
            }
        //     else if (key == 'a' || key == 'A') {
        //         barTop.speed(increase);
        //     }
        //     else if (key == 'z' || key == 'Z') {
        //         barTop.speed(!increase);
        //     }
        //     else if (key == 'w' || key == 'W') {
        //         barTop.controlInverted = !barTop.controlInverted;
        //     }
        //     else if (key == 'x' || key == 'X') {
        //         barBottom.controlInverted = !barBottom.controlInverted;
        //     }
        //       else if (key == '0' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(0));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '1' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(1));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '2' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(2));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        //      else if (key == '3' && !hasWaitedToReadInput) {
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //          println("returnValue: "+simonResolver.compareSolution(3));
        //          delay(500);
        //          hasWaitedToReadInput = !hasWaitedToReadInput;
        //      }
        }
    }
}

void displayLauncher(int currentMillis)
{
    if(fightLauncherBottom.fontSize >= 200) {
        launcherNeedTowait = true;
        currentTimer = fightLauncherBottom.valueToDisplay;
        if(currentTimer == "3") {
            fightLauncherBottom.valueToDisplay = "2";
            fightLauncherBottom.fontSize = 0;
        }
        else if(currentTimer == "2") {
            fightLauncherBottom.valueToDisplay = "1";
            fightLauncherBottom.fontSize = 0;
        }
        else if(currentTimer == "1") {
            fightLauncherBottom.valueToDisplay = "FIGHT !";
            fightLauncherBottom.fontSize = 0;
        }
        else if(currentTimer == "FIGHT !") {
            fightLauncherBottom.valueToDisplay = "";
            fightLauncherBottom.fontSize = 0;
            pongCanBeLaunched = true;
        }
    }
    if(currentMillis - previousMillis > interval && fightLauncherBottom.valueToDisplay != "" && !launcherNeedTowait) {
        previousMillis = currentMillis;
        fightLauncherBottom.fontSize += 7;
    }
    else if(currentMillis - previousMillis > pauseInterval && launcherNeedTowait) {
        previousMillis = currentMillis;
        launcherNeedTowait = false;
    }
}