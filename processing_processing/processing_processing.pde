import processing.serial.*;

Serial myPort;
String stringReceived;
String[] moves;
int playerTop;
int playerBottom;
int screenWidth  = 800;
int screenHeight = 600;

<<<<<<< HEAD
//Players

ArrayList<Player> players = new ArrayList<Player>();
Player player_1;
Player player_2;
Player player_3;
Player player_4;
=======

// Players
int nbPlayers = 4;
Player[] players = new Player[nbPlayers];

// Bars
Bar[] bars = new Bar[nbPlayers];
int barWidth = 100;
int barHeight = 20;
int barSpeed = 5;
boolean increase = true;
>>>>>>> FETCH_HEAD

// Ball
Ball ball;

int radiusBall = 20;
int posXBall = screenWidth / 2;
int posYBall = screenHeight / 2;

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

// ColorSequence
int colorWidth = 100;
int colorHeight = 300;
int colorSpacing = 50;
ColorSequence colorsToDisplay;


boolean hasWaited = false;

void setup() {
    
    //instantiaterduino();

    size(screenWidth, screenHeight);
    background(41, 41, 41);

    int i = 0;
    for (i = 0; i < nbPlayers; i++) {
        bars[i] = new Bar(barWidth, barHeight, i);
        players[i] = new Player(i + 1, bars[i]);
    }

    ball = new Ball(radiusBall, posXBall, posYBall);
    // barTop = new Bar(barWidth, barHeight, posXBarTop, posYBarTop, barSpeed);
    // barBottom = new Bar(barWidth, barHeight, posXBarBottom, posYBarBottom, barSpeed);
    scorePlayerTop = new Score(scorePlayer, scorePosYTop);
    scorePlayerBottom = new Score(scorePlayer, scorePosYBottom);
    colorsToDisplay = new ColorSequence(screenWidth, screenHeight, colorWidth, colorHeight, colorSpacing);
    
    player_1 = new Player();
    player_2 = new Player();
    player_3 = new Player();
    player_4 = new Player();
    
    players.add(player_1);
    players.add(player_2);
    players.add(player_3);
    players.add(player_4);
    
    pong_1 = new Pong();
}

void draw()
{
<<<<<<< HEAD
    pong_1.drawPong();
=======
    background(41, 41, 41);

    drawLine();

    scorePlayerTop.displayScore();
    scorePlayerBottom.displayScore();

    // barTop.drawBar();
    // barBottom.drawBar();
    int i = 0;
    for (i = 0; i < nbPlayers; i++) {
        players[i].bar.draw();
    }

    // Score
    if (ball.posYBall > screenHeight) {
        scorePlayerTop.scorePlayer += 1;
        ball.initBall();
    }
    else if (ball.posYBall < 0) {
        scorePlayerBottom.scorePlayer += 1;
        ball.initBall();
    }
>>>>>>> FETCH_HEAD

    // ColorSequence
    // colorsToDisplay.drawSequence();

<<<<<<< HEAD
=======
    // Ball
    ball.moveBall();

    // if (ball.testBallHitBar(barTop)) {
    //     ball.changeBallDirection(barTop.posXBar, 1);
    // }
    // else if (ball.testBallHitBar(barBottom)) {
    //     ball.changeBallDirection(barBottom.posXBar, -1);
    // }
    
>>>>>>> FETCH_HEAD
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
                /* from 0 to 255 */
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
        // if (key == CODED) {
        //     if (keyCode == LEFT) {
        //          if (!barTop.controlInverted && barTop.posXBar > 0) {
        //              barTop.posXBar -= 5;
        //          }
        //          else if (barTop.controlInverted && barTop.posXBar < screenWidth - barTop.barWidth) {
        //              barTop.posXBar += 5;
        //          }
        //      }
        //      else if (keyCode == RIGHT) {
        //          if (!barTop.controlInverted && barTop.posXBar < screenWidth - barTop.barWidth) {
        //              barTop.posXBar += 5;
        //          }
        //          else if (barTop.controlInverted && barTop.posXBar > 0) {
        //              barTop.posXBar -= 5;
        //          }
        //      }
        // }
        // else {
        //     if (key == 'q' || key == 'Q') {
        //          if (!barBottom.controlInverted && barBottom.posXBar > 0) {
        //              barBottom.posXBar -= 5;
        //          }
        //          else if (barBottom.controlInverted && barBottom.posXBar < screenWidth - barBottom.barWidth) {
        //              barBottom.posXBar += 5;
        //          }
        //      }
        //      else if ((key == 's' || key == 'S')) {
        //          if (!barBottom.controlInverted && barBottom.posXBar < screenWidth - barBottom.barWidth) {
        //              barBottom.posXBar += 5;
        //          }
        //          else if (barBottom.controlInverted && barBottom.posXBar > 0) {
        //              barBottom.posXBar -= 5;
        //          }
        //      }
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
        // }
    }
}



