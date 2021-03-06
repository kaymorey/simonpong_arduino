import processing.serial.*;
import ddf.minim.*;

int previousMillis = 0;

/////////////
// Arduino //
/////////////
Serial myPort1;
Serial myPort2;
String stringReceived1;
String stringReceived2;
String stringToSend1;
String stringToSend2;
String[] moves1;
String[] moves2;
boolean hasWaited = false;
boolean dataCanBeSent = false;
String playerToSend;
String winingTeam;

boolean gameAsBeenInitialized = false;

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
// int screenWidth  = 1200;
// int screenHeight = 700;

//////////
// Pong //
//////////
int level;
int levelDuration = 50000;
int levelTimer;
int levelMaxTime;
int transitionLevelCounter;
int nbLevelsPlayed;
int nbRoundsWinOne;
int nbRoundsWinTwo;

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
int playerBottomLeft;
int playerBottomRight;

///////////
// Score //
///////////
int scorePosYBottom = screenHeight - (screenHeight / 4 - 50);

///////////
// Simon //
///////////
Simon simon;
int numberOfLed = 4;
int numberOfColorInSequence = 4;
// boolean hasWaitedToReadInput = false;
boolean firstSequenceHasBeenSent = false;

boolean sequenceNeedtoBeRestarted = false;

///////////////////
// fightLauncher //
///////////////////
int interval = 5;
int pauseInterval = 300;
FightLauncher fightLauncher;
boolean launcherNeedTowait;
String currentTimer;
boolean pongCanBeLaunched;
boolean demoHasBeenStopped;

void setup()
{
    ///////////////////
    // fightLauncher //
    ///////////////////
    launcherNeedTowait = false;
    pongCanBeLaunched = false;
    demoHasBeenStopped = false;
    fightLauncher = new FightLauncher("3", 5, screenHeight/4);

    //////////
    // Game //
    //////////
    minim = new Minim(this);
    game = new Game(minim);

    /////////////
    // Arduino //
    /////////////
    if(!gameAsBeenInitialized) {
        gameAsBeenInitialized = true;
        instantiateArduino();
        game.backgroundSound.player.loop();
    }

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

    //////////
    // Pong //
    //////////
        int levelIndex = int(random(game.randomLevels.length));
        level = game.randomLevels[levelIndex];
        game.randomLevels = remove(game.randomLevels, levelIndex);

        transitionLevelCounter = 0;
        nbLevelsPlayed = 0;
        nbRoundsWinOne = 0;
        nbRoundsWinTwo = 0;

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
        pongDiagonalTLBR = new Pong(game, screenWidth, screenHeight, 0, 0, color(41, 118, 174), players, 4);
        pongDiagonalTRBL = new Pong(game, screenWidth, screenHeight, 0, 0, color(238, 148, 39), players, 5);

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
    if (game.activeScreen == 2) {
        int currentMillis = millis();
        // End of level
        if (currentMillis - levelTimer >= levelDuration) {
            transitionLevelCounter += 1;
            if (transitionLevelCounter <= 100) {
                game.drawTimesUpPhrase();
                winingTeam = calculateScore();
            }
            else if (transitionLevelCounter >= 100 && transitionLevelCounter <= 200) {
                game.drawWiningTeamPhrase(winingTeam);
            }
            else if (transitionLevelCounter >= 200) {
                transitionLevelCounter = 0;
                nbLevelsPlayed += 1;
                if (nbLevelsPlayed <= 1) {
                    int levelIndex = int(random(game.randomLevels.length));
                    level = game.randomLevels[levelIndex];
                    game.randomLevels = remove(game.randomLevels, levelIndex);
                    resetPongs();
                }
                else if (nbLevelsPlayed == 2) {
                    level = 4;
                    resetPongs();
                }
                else {
                    if (nbRoundsWinOne == nbRoundsWinTwo && nbLevelsPlayed == 3) {
                        int levelIndex = int(random(game.randomLevels.length));
                        level = game.randomLevels[levelIndex];
                        game.randomLevels = remove(game.randomLevels, levelIndex);
                        resetPongs();
                    }
                    else {
                        previousMillis = millis();
                        game.activeScreen = 3;
                    }
                }

                background(255);
            }
        }

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


        fightLauncher.draw();
        fightLauncher.displayLauncher(currentMillis);
    }

    else if (game.activeScreen == 0 || game.activeScreen == 1) {
        if (game.pressPhraseOpacity < 255 && game.increasePhraseOpacity) {
            game.pressPhraseOpacity += 6;
        }
        else if (game.pressPhraseOpacity > 0 && !game.increasePhraseOpacity) {
            game.pressPhraseOpacity -= 6;
        }
        else if (game.pressPhraseOpacity >= 255) {
            game.increasePhraseOpacity = false;
        }
        else if (game.pressPhraseOpacity <= 0) {
            game.increasePhraseOpacity = true;
        }

        if (game.activeScreen == 0) {
            game.drawInitialScreen();
        }
        else {
            int currentMillis = millis();
            if (currentMillis - previousMillis > 6000) {
                game.activeScreen = 2;
            }
            game.drawInstructionsScreen();
        }
    }
    else if (game.activeScreen == 3) {
        int currentMillis = millis();
        if (currentMillis - previousMillis <= 5000) {
            game.drawLastScreen();
        }
        else {
            setup();
        }
    }

    /////////////
    // Arduino //
    /////////////
    readArduino();
    //readKeyboard();
    sendArduino();
}

void resetPongs()
{
    pongLeft.resetBars();
    pongRight.resetBars();

    pongTop.resetBars();
    pongBottom.resetBars();

    pongDiagonalTLBR.resetBars();
    pongDiagonalTRBL.resetBars();

    pongFull.resetBars();
}

String calculateScore()
{
    int scoreOne = 0;
    int scoreTwo = 0;

    switch (level) {
        case 1 :
            scoreOne = pongLeft.scoreTeamOne.scorePlayer + pongRight.scoreTeamOne.scorePlayer;
            scoreTwo = pongLeft.scoreTeamTwo.scorePlayer + pongRight.scoreTeamTwo.scorePlayer;
            break;
        case 2 :
            scoreOne = pongTop.scoreTeamOne.scorePlayer;
            scoreTwo = pongBottom.scoreTeamOne.scorePlayer;
            break;
        case 3 :
            scoreOne = pongDiagonalTLBR.scoreTeamOne.scorePlayer + pongDiagonalTRBL.scoreTeamOne.scorePlayer;
            scoreTwo = pongDiagonalTLBR.scoreTeamTwo.scorePlayer + pongDiagonalTRBL.scoreTeamTwo.scorePlayer;
        default :
            scoreOne = pongFull.scoreTeamOne.scorePlayer;
            scoreTwo = pongFull.scoreTeamTwo.scorePlayer;
            break;
    }

    int hand = nbLevelsPlayed + 1;
    if (scoreOne > scoreTwo) {
        nbRoundsWinOne += 1;
        return "Team one wins round " + hand + " !";
    }
    else if (scoreTwo > scoreOne) {
        nbRoundsWinTwo += 1;
        return "Team two wins round" + hand + " !";
    }
    else {
        return "Draw round " + hand + " !";
    }
}

void instantiateArduino()
{
    String portName1 = Serial.list()[4];
    myPort1 = new Serial(this, portName1, 9600);

    String portName2 = Serial.list()[8];
    myPort2 = new Serial(this, portName2, 9600);
}

void readArduino()
{
    if(!hasWaited){
        hasWaited = true;
        delay(1000);
        simon.play();
    }

    if(myPort1.available() > 0){
        stringReceived1 = myPort1.readStringUntil('\n');
        if(stringReceived1 != null) {
            moves1 = split(stringReceived1,'$');
            //println("stringReceived: "+stringReceived);
            if(moves1.length == 4){
                if(game.activeScreen == 0) {
                    if(int(moves1[2].trim()) != 255 || int(moves1[3].trim()) != 255) {
                        game.activeScreen = 1;
                        previousMillis = millis();
                        background(255);
                    }
                }
                else {
                    switch (int(moves1[2].trim())) {
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
                    switch (int(moves1[3].trim())) {
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

                    // if(returnedValueByResolver == 2) {
                    //     resetSimon();
                    // }


                    playerTopLeft = int(moves1[1].trim());
                    playerTopRight = int(moves1[0].trim());
                    /* from 0 to 255 */
                    // println("playerLeft: "+playerLeft);
                    // println("playerRight: "+playerRight);
                    players.get(0).bar.posX = (screenWidth/2-players.get(0).bar.width)-playerTopLeft*(screenWidth/2-players.get(0).bar.width)/255;
                    players.get(1).bar.posX = (screenWidth/2-players.get(0).bar.width)-playerTopRight*(screenWidth/2-players.get(1).bar.width)/255 + screenWidth/2;

                    // players.get(2).bar.posX = playerTopLeft*(screenWidth/2-players.get(2).bar.width)/255;
                    // players.get(3).bar.posX = playerTopRight*(screenWidth/2-players.get(3).bar.width)/255 + screenWidth/2;
                }
            }
        }
    }

    if(myPort2.available() > 0){
        //println("test");
        stringReceived2 = myPort2.readStringUntil('\n');
        if(stringReceived2 != null) {
            moves2 = split(stringReceived2,'$');
            //println("stringReceived: "+stringReceived);
            if(moves2.length == 4){
                if(game.activeScreen == 0) {
                    if(int(moves2[2].trim()) != 255 || int(moves2[3].trim()) != 255) {
                        game.activeScreen = 1;
                    }
                }
                else {
                    // joueur top left
                    switch (int(moves2[2].trim())) {
                        case 0 :
                            players.get(2).returnedValueByResolver = players.get(2).resolver.compareSolution(0);
                            break;
                        case 1 :
                            players.get(2).returnedValueByResolver = players.get(2).resolver.compareSolution(1);
                            break;
                        case 2 :
                            players.get(2).returnedValueByResolver = players.get(2).resolver.compareSolution(2);
                            break;
                        case 3 :
                            players.get(2).returnedValueByResolver = players.get(2).resolver.compareSolution(3);
                            break;
                    }
                    // joueur top right
                    switch (int(moves2[3].trim())) {
                        case 0 :
                            players.get(3).returnedValueByResolver = players.get(3).resolver.compareSolution(0);
                            break;
                        case 1 :
                            players.get(3).returnedValueByResolver = players.get(3).resolver.compareSolution(1);
                            break;
                        case 2 :
                            players.get(3).returnedValueByResolver = players.get(3).resolver.compareSolution(2);
                            break;
                        case 3 :
                            players.get(3).returnedValueByResolver = players.get(3).resolver.compareSolution(3);
                            break;
                    }

                    // if(returnedValueByResolver == 2) {
                    //     resetSimon();
                    // }
                    // for (int i = 0; i < playersNumber; i++) {
                    //     if(players.get(i).returnedValueByResolver == 2) {
                    //         resetSimon(i);
                    //     }
                    //     else if(players.get(i).returnedValueByResolver == 0) {
                    //         players.get(i).returnedValueByResolver = 3;
                    //         restartSequenceForPlayer(i);
                    //     }
                    // }

                    playerBottomLeft = int(moves2[1].trim());
                    playerBottomRight = int(moves2[0].trim());
                    /* from 0 to 255 */
                    // println("playerLeft: "+playerLeft);
                    // println("playerRight: "+playerRight);
                    players.get(2).bar.posX = playerBottomLeft*(screenWidth/2-players.get(2).bar.width)/255;
                    players.get(3).bar.posX = playerBottomRight*(screenWidth/2-players.get(3).bar.width)/255 + screenWidth/2;
                }
            }
        }
    }

    for (int i = 0; i < playersNumber; i++) {
        
        PImage resultSequenceImage;
        resultSequenceImage = loadImage("check.png");
        
        switch (i) {
            case 1: // Top right
                imagePosX = -(3 * screenWidth / 4 - resultSequenceImage.width / 2);
                imagePosY = - 150;
                break;
            case 2: // Bottom left
                imagePosX = screenWidth / 4 - resultSequenceImage.width / 2;
                imagePosY = screenHeight - 150;
                break;
            case 3: // Bottom right
                imagePosX = 3 * screenWidth / 4 - resultSequenceImage.width / 2;
                imagePosY = screenHeight - 150;
                break;
            default : // Top left
                imagePosX = -(screenWidth / 4 - resultSequenceImage.width / 2);
                imagePosY = - 150;
                break;
        }
        
        if(players.get(i).returnedValueByResolver == 2 && !sequenceNeedtoBeRestarted) {

            int power = int(random(0, 2));
            
            image(resultSequenceImage, imagePosX, imagePosY);

            switch (power) {
                case 0 :
                    players.get(i).bar.expand();
                    break;
                case 1 :
                    pongLeft.ball.transparentMalus = true;
                    pongLeft.ball.isTransparent = true;

                    pongRight.ball.transparentMalus = true;
                    pongRight.ball.isTransparent = true;

                    pongTop.ball.transparentMalus = true;
                    pongTop.ball.isTransparent = true;

                    pongBottom.ball.transparentMalus = true;
                    pongBottom.ball.isTransparent = true;
                    break;
                default :
                    players.get(i).bar.shrink();
                    break;
            }

            sequenceNeedtoBeRestarted = true;
        }
        else if(players.get(i).returnedValueByResolver == 0) {
            
            resultSequenceImage = loadImage("cross.png");
            image(resultSequenceImage, imagePosX, imagePosY);
          
            players.get(i).returnedValueByResolver = 3;
            restartSequenceForPlayer(i);
        }
    }

    if(sequenceNeedtoBeRestarted) {
        resetSimon();
    }
}

void sendArduino()
{
    if(game.activeScreen == 1 && !demoHasBeenStopped) {
        demoHasBeenStopped = true;
        myPort1.write("stopDemo\n");
        myPort2.write("stopDemo\n");
    }
    else if(pongCanBeLaunched && !firstSequenceHasBeenSent) {
        firstSequenceHasBeenSent = true;
        myPort1.write("firstSequence\n");
        myPort2.write("firstSequence\n");
        stringToSend1 = "0$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend1 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend1 += "\n";
        //println("stringToSend: "+stringToSend);
        myPort1.write(stringToSend1);

        stringToSend2 = "0$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend2 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend2+= "\n";
        //println("stringToSend: "+stringToSend);
        myPort2.write(stringToSend2);
    }
    else if(dataCanBeSent) {

        dataCanBeSent = false;
        stringToSend1 = "0$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend1 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend1 += "\n";
        //println("stringToSend: "+stringToSend);
        myPort1.write(stringToSend1);
        stringToSend2 = "0$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend2 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend2 += "\n";
        //println("stringToSend: "+stringToSend);
        myPort2.write(stringToSend2);
    }
}

void restartSequenceForPlayer(int player) {
    switch(player) {
        case 0:
            playerToSend = "1";
            break;
        case 1:
            playerToSend = "2";
            break;
        case 2:
            playerToSend = "1";
            break;
        case 3:
            playerToSend = "2";
            break;
    }
    if(player == 0 || player == 1) {
        stringToSend1 = playerToSend+"$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend1 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend1 += "\n";
        myPort1.write(stringToSend1);
    }
    if(player == 2 || player == 3) {
        stringToSend2 = playerToSend+"$"+str(numberOfColorInSequence);
        for(int i = 0; i < numberOfColorInSequence; i++) {
            stringToSend2 += "$"+str(simon.sequenceToPlay.get(i));
        }
        stringToSend2 += "\n";
        myPort2.write(stringToSend2);
    }
}

void resetSimon()
{
    sequenceNeedtoBeRestarted = false;
    for (int i = 0; i < playersNumber; i++) {
        players.get(i).returnedValueByResolver = 0;
    }
    // simon.win(player);
    simon = new Simon(numberOfColorInSequence,numberOfLed);
    for (int i = 0; i < playersNumber; i++) {
        players.get(i).resolver = new SimonResolver(simon.sequenceToPlay);
        players.get(i).returnedValueByResolver = 3;
    }
    simon.play();
    dataCanBeSent = true;
    sendArduino();
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
                previousMillis = millis();
                background(255);
            }
            // Controls for bottom left bar
            if (key == 'q' || key == 'Q') {
                /*
                if (!players.get(2).bar.controlInverted && players.get(2).bar.posX > 0) {
                    players.get(2).bar.posX -= 5;
                }
                else if (players.get(2).bar.controlInverted && players.get(2).bar.posX < screenWidth / 2 - players.get(2).bar.width) {
                    players.get(2).bar.posX += 5;
                }*/

                players.get(2).bar.reverse(false);
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

int[] remove(int array[], int item) {
    int outgoing[] = new int[array.length - 1];
    System.arraycopy(array, 0, outgoing, 0, item);
    System.arraycopy(array, item+1, outgoing, item, array.length - (item + 1));
    return outgoing;
}
