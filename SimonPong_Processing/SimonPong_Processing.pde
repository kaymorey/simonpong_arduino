import processing.serial.*;
int previousMillis = 0;

Serial myPort;
String stringReceived;
String stringToSend;
String[] moves;

// int playerTop;
// int playerBottom;
int screenWidth  = 1280;
int screenHeight = 768;

int playerTopLeft;
int playerTopRight;

// Pong
Pong pongLeft;
Pong pongRight;
Pong pongTop;
Pong pongBottom;
Pong pongDiagonalTLBR;
Pong pongDiagonalTRBL;
Pong pongFull;

// Players
int playersNumber = 4;
ArrayList<Player> players = new ArrayList<Player>();

// Ball
Ball ballLeft;
Ball ballRight;
Ball ballTop;
Ball ballBottom;
Ball ballFull;
int radiusBall = 20;
int posXBall = screenWidth / 2;
int posYBall = screenHeight / 2;

// Score
Score scorePlayerTop;
Score scorePlayerBottom;
int scorePlayer = 0;
// Score Top
int scorePosYTop = screenHeight / 4 + 50;
// Score Bottom
int scorePosYBottom = screenHeight - (screenHeight / 4 - 50);

// Simon
Simon simon;
int numberOfLed = 4;
int numberOfColorInSequence = 3;

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;
int returnedValueByResolver = 0; // /!\ cette variable doit être celle du joueur et récupérée pour chaque joueur. N'apparaît pas dans le main.


boolean hasWaited = false;
boolean firstContact = false;

///////////////////
// fightLauncher //
///////////////////
int interval = 5;
int pauseInterval = 300;
FightLauncher fightLauncherBottom;
boolean launcherNeedTowait = false;
String currentTimer;
boolean pongCanBeLaunched = true;


void setup() {
    
    instantiateArduino();

    size(screenWidth, screenHeight);

    for (int i = 0; i < playersNumber; i++) {
        players.add(new Player(i));
    }

    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    ///////////////////
    // fightLauncher //
    ///////////////////
    fightLauncherBottom = new FightLauncher("3",5,scorePosYBottom);

    ////////////
    // Mode 1 //
    ////////////
    ballLeft = new Ball(radiusBall, posXBall/2, posYBall);
    ballRight = new Ball(radiusBall, 3*(screenWidth/4), posYBall);

    pongLeft = new Pong(screenWidth/2, screenHeight, 0, 0, color(41, 118, 174), players, ballLeft, 0);
    pongRight = new Pong(screenWidth/2, screenHeight, screenWidth/2, 0, color(238, 148, 39), players, ballRight, 1);

    ////////////
    // Mode 2 //
    ////////////
    ballTop = new Ball(radiusBall, screenWidth/4, posYBall/2);
    ballBottom = new Ball(radiusBall, 3*(screenWidth/4), 3*(screenHeight/4));

    pongTop = new Pong(screenWidth, screenHeight/2, 0, 0, color(41, 118, 174), players, ballTop, 2);
    pongBottom = new Pong(screenWidth, screenHeight/2, 0, screenHeight/2, color(238, 148, 39), players, ballBottom, 3);

    ////////////
    // Mode 3 //
    ////////////

    ////////////
    // Mode 4 //
    ////////////
    ballFull = new Ball(radiusBall, screenWidth/2, screenHeight/2);

    pongFull = new Pong(screenWidth, screenHeight, 0, 0, color(169, 76, 79), players, ballFull, 6);
    ////////////

    simon = new Simon(numberOfColorInSequence, numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    //simon.play();
}

void draw()
{
    ////////////
    // Mode 1 //
    ////////////
    //pongLeft.draw();
    //pongRight.draw();

    ////////////
    // Mode 2 //
    ////////////
    if(pongCanBeLaunched) {
        pongTop.draw();
        pongBottom.draw();
    }

    ////////////
    // Mode 3 //
    ////////////

    ////////////
    // Mode 4 //
    ////////////
    //pongFull.draw();

/*
    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();
*/
    fightLauncherBottom.draw();
    int currentMillis = millis();
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

    readArduino();
    //readKeyboard();
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
                        returnedValueByResolver = simonResolver.compareSolution(0);
                        break;
                    case 1 :
                        returnedValueByResolver = simonResolver.compareSolution(1);
                        break;
                    case 2 :
                        returnedValueByResolver = simonResolver.compareSolution(2);
                        break;
                    case 3 :
                        returnedValueByResolver = simonResolver.compareSolution(3);
                        break;
                }
                // joueur top right
                switch (int(moves[3].trim())) {
                    case 0 :
                        returnedValueByResolver = simonResolver.compareSolution(0);
                        break;
                    case 1 :
                        returnedValueByResolver = simonResolver.compareSolution(1);
                        break;
                    case 2 :
                        returnedValueByResolver = simonResolver.compareSolution(2);
                        break;
                    case 3 :
                        returnedValueByResolver = simonResolver.compareSolution(3);
                        break;
                }

                if(returnedValueByResolver == 2) {
                    resetSimon();
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

void sendStringToArduino() {
    stringToSend = str(numberOfColorInSequence);
    for(int i = 0; i < numberOfColorInSequence; i++) {
        stringToSend += "$"+str(simon.sequenceToPlay.get(i));
    }
    stringToSend += "\n";
    println(stringToSend);
    myPort.write(stringToSend);
}

void resetSimon()
{
    returnedValueByResolver = 0;
    simon.win();
    simon = new Simon(++numberOfColorInSequence,numberOfLed);
    simonResolver = new SimonResolver(simon.sequenceToPlay);
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
                players.get(0).bar.expandBar();
            }
            else if (key == 'r' || key == 'R') {
                players.get(0).bar.shrinkBar();
            }
            else if (key == 'i' || key == 'I') {
                pongLeft.ball.transparentMalus = true;
                pongLeft.ball.isTransparent = true;
            }
        //     else if (key == 'a' || key == 'A') {
        //         barTop.speedBar(increase);
        //     }
        //     else if (key == 'z' || key == 'Z') {
        //         barTop.speedBar(!increase);
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
