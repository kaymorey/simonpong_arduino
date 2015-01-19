import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerTop;
int playerBottom;
int screenWidth  = 1920;
int screenHeight = 1080;

// Ball
Ball ball;

int radiusBall = 20;
int posXBall = (screenWidth - radiusBall)/2;
int posYBall = (screenHeight - radiusBall)/2;

// Bar
Bar barTop;
Bar barBottom;

int barWidth = 100;
int barHeight = 20;
int barSpeed = 5;
boolean increase = true;
// Bar Top
int posXBarTop = (screenWidth - barWidth)/2;
int posYBarTop = 0;
// Bar Bottom
int posXBarBottom = (screenWidth - barWidth)/2;
int posYBarBottom = screenHeight - barHeight;

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

    ball = new Ball(radiusBall, posXBall, posYBall);
    barTop = new Bar(barWidth, barHeight, posXBarTop, posYBarTop, barSpeed);
    barBottom = new Bar(barWidth, barHeight, posXBarBottom, posYBarBottom, barSpeed);
    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);
    simon = new Simon(5, 4);
    simonResolver = new SimonResolver(simon.sequenceToPlay);

    simon.play();
}

void draw()
{
    background(41, 41, 41);

    drawLine();

    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();

    barTop.drawBar();
    barBottom.drawBar();

    // Score
    if (ball.posYBall > screenHeight) {
        scorePlayerTop.scorePlayer += 1;
        ball.initBall();
    }
    else if (ball.posYBall < 0) {
        scorePlayerBottom.scorePlayer += 1;
        ball.initBall();
    }

    // Ball
    ball.moveBall();

    if (ball.testBallHitBar(barTop.posXBar, barTop.posYBar)) {
        ball.changeBallDirection(barTop.posXBar, 1);
    }
    else if (ball.testBallHitBar(barBottom.posXBar, barBottom.posYBar)) {
        ball.changeBallDirection(barBottom.posXBar, -1);
    }
    
    //readArduino();
    readKeyboard();
}

void drawLine()
{
    stroke(28, 28, 28);
    line(0, screenHeight / 2, screenWidth, screenHeight / 2);
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
                barTop.posXBar = playerTop*(screenWidth-barTop.barWidth)/255;
                barBottom.posXBar = playerBottom*(screenWidth-barBottom.barWidth)/255;
            }
        }
    }
}

void readKeyboard()
{
    if (keyPressed) {
        if (key == CODED) {
            if (keyCode == LEFT) {
                 if (!barTop.controlInverted && barTop.posXBar > 0) {
                     barTop.posXBar -= 5;
                 }
                 else if (barTop.controlInverted && barTop.posXBar < screenWidth - barWidth) {
                     barTop.posXBar += 5;
                 }
             }
             else if (keyCode == RIGHT) {
                 if (!barTop.controlInverted && barTop.posXBar < screenWidth - barWidth) {
                     barTop.posXBar += 5;
                 }
                 else if (barTop.controlInverted && barTop.posXBar > 0) {
                     barTop.posXBar -= 5;
                 }
             }
        }
        else {
            if (key == 'q' || key == 'Q') {
                 if (!barBottom.controlInverted && barBottom.posXBar > 0) {
                     barBottom.posXBar -= 5;
                 }
                 else if (barBottom.controlInverted && barBottom.posXBar < screenWidth - barWidth) {
                     barBottom.posXBar += 5;
                 }
             }
             else if ((key == 's' || key == 'S')) {
                 if (!barBottom.controlInverted && barBottom.posXBar < screenWidth - barWidth) {
                     barBottom.posXBar += 5;
                 }
                 else if (barBottom.controlInverted && barBottom.posXBar > 0) {
                     barBottom.posXBar -= 5;
                 }
             }
            else if (key == 'e' || key == 'E') {
                barTop.expandBar();
            }
            else if (key == 'r' || key == 'R') {
                barTop.shrinkBar();
            }
            else if (key == 'a' || key == 'A') {
                barTop.speedBar(increase);
            }
            else if (key == 'z' || key == 'Z') {
                barTop.speedBar(!increase);
            }
            else if (key == 'w' || key == 'W') {
                barTop.controlInverted = !barTop.controlInverted;
            }
            else if (key == 'x' || key == 'X') {
                barBottom.controlInverted = !barBottom.controlInverted;
            }
            else if (key == '0' && !hasWaitedToReadInput) {
                hasWaitedToReadInput = !hasWaitedToReadInput;
                println("returnValue: "+simonResolver.compareSolution(0));
                delay(500);
                hasWaitedToReadInput = !hasWaitedToReadInput;
            }
            else if (key == '1' && !hasWaitedToReadInput) {
                hasWaitedToReadInput = !hasWaitedToReadInput;
                println("returnValue: "+simonResolver.compareSolution(1));
                delay(500);
                hasWaitedToReadInput = !hasWaitedToReadInput;
            }
            else if (key == '2' && !hasWaitedToReadInput) {
                hasWaitedToReadInput = !hasWaitedToReadInput;
                println("returnValue: "+simonResolver.compareSolution(2));
                delay(500);
                hasWaitedToReadInput = !hasWaitedToReadInput;
            }
            else if (key == '3' && !hasWaitedToReadInput) {
                hasWaitedToReadInput = !hasWaitedToReadInput;
                println("returnValue: "+simonResolver.compareSolution(3));
                delay(500);
                hasWaitedToReadInput = !hasWaitedToReadInput;
            }
        }
    }
}



