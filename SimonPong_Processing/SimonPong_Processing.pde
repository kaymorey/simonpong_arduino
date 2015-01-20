import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerTop;
int playerBottom;
int screenWidth  = 1280;
int screenHeight = 768;

// Pong
Pong pongLeft;
Pong pongRight;

// Players
int playersNumber = 4;
ArrayList<Player> players = new ArrayList<Player>();

// Ball
Ball balls;
Ball balls2;
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

// SimonResolver
SimonResolver simonResolver;
boolean hasWaitedToReadInput = false;


boolean hasWaited = false;

void setup() {

    //instantiaterduino();

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    for (int i = 0; i < playersNumber; i++) {
        players.add(new Player(i));
    }

    balls = new Ball(radiusBall, posXBall/2, posYBall);
    balls2 = new Ball(radiusBall, 3*(screenWidth/4), posYBall);

    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);

    pongLeft = new Pong(screenWidth/2, screenHeight, 0, 0, color(41, 41, 41), players, balls, 0);
    pongRight = new Pong(screenWidth/2, screenHeight, screenWidth/2, 0, color(20, 40, 80), players, balls2, 1);

    simon = new Simon(5, 4);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    simon.play();
}

void draw()
{
    pongLeft.draw();
    pongRight.draw();
/*
    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();
*/

    //readArduino();
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
    }

    if(myPort.available() > 0){
        stringReceived = myPort.readStringUntil('\n');
        if(stringReceived != null) {

            moves = split(stringReceived,'$');

            if(moves.length == 2){

                playerTop = int(moves[0].trim());
                playerBottom = int(moves[1].trim());
                /* from 0q to 255 */
                // println("playerLeft: "+playerLeft);
                // println("playerRight: "+playerRight);
                // barTop.posXBar = playerTop*(screenWidth-barTop.barWidth)/255;
                // barBottom.posXBar = playerBottom*(screenWidth-barBottom.barWidth)/255;
            }
        }
    }
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
             if (key == 'a' || key == 'A') {
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
             if (key == 'w' || key == 'W') {
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
        //     else if (key == 'e' || key == 'E') {
        //         barTop.expandBar();
        //     }
        //     else if (key == 'r' || key == 'R') {
        //         barTop.shrinkBar();
        //     }
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



