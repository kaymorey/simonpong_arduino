//////////
// Ball //
//////////
int radiusBall = 20;
int posXBall;
int posYBall;

class Pong
{
    Game game;
    int width;
    int height;
    int posX;
    int posY;
    color backgroundColor;
    color backgroundColor2;
    ArrayList<Player> players;
    Ball ball;
    int mode;
    int lastBarTouched = -1;

    Pong(Game pongGame, int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, ArrayList<Player> pongPlayers, int pongMode) {

        game = pongGame;
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        mode = pongMode;

        switch (mode) {
            case 0 :
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 2;
                break;
            case 1 :
                posXBall = 3 * (screenWidth / 4);
                posYBall = screenHeight / 2;
                break;
            case 2 :
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 4;
                break;
            case 3 :
                posXBall = 3 * (screenWidth / 4);
                posYBall = 3 * (screenHeight / 4);
                break;
            case 4 :
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 2 - 50;
                backgroundColor2 = color(41, 118, 174);
                break;
            case 5 :
                posXBall = 3 * (screenWidth / 4);
                posYBall = screenHeight / 2 - 50;
                backgroundColor2 = color(238, 148, 39);
                break;
            default :
                posXBall = screenWidth / 2;
                posYBall = screenHeight / 2;
                break;
        }

        ball = new Ball(radiusBall, posXBall, posYBall);

        drawBackground(255);
    }

    void draw()
    {

        drawBackground(80);
        drawLine();
        drawPlayer();
        play();
        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        */
    }

    void drawBackground(int bgAlpha)
    {
        if (mode == 4) {
            noStroke();
            fill(backgroundColor2, bgAlpha);
            rect(0, 0, width/2, height/2);

            noStroke();
            fill(backgroundColor2, bgAlpha);
            rect(width/2, height/2, width/2, height/2);
        }
        else if (mode == 5) {
            noStroke();
            fill(backgroundColor2, bgAlpha);
            rect(width/2, 0, width/2, height/2);

            noStroke();
            fill(backgroundColor2, bgAlpha);
            rect(0, height/2, width/2, height/2);
        }
        else {
            noStroke();
            fill(backgroundColor, bgAlpha);
            rect(posX, posY, width, height);
        }
    }

    void drawLine()
    {
        float redColor = red(backgroundColor)-30;
        float greenColor = green(backgroundColor)-30;
        float blueColor = blue(backgroundColor)-30;

        stroke(redColor, greenColor, blueColor);
        line(posX, posY + height / 2, posX + width, posY + height / 2);
    }

    void drawPlayer()
    {
        players.get(0).draw();
        players.get(1).draw();
        players.get(2).draw();
        players.get(3).draw();
    }

    void play()
    {
        // Score
        if (ball.posY > posY + height) {
            game.loseSound.player.play();
            ball.initBall();
            game.loseSound.player.rewind();

            if (mode != 2) {
                scoreTeamTop.scorePlayer += 1;
            }
        }
        else if (ball.posY < 0) {
            game.loseSound.player.play();
            ball.initBall();
            game.loseSound.player.rewind();

            if (mode != 2) {
                scoreTeamBottom.scorePlayer += 1;
            }
        }

        // Ball
        ball.moveBall(width, height, posX, posY, mode);

        if (ball.testBallHitBar(players.get(0).bar)) {
            ball.changeBallDirection(players.get(0).bar.posX, 1);
        }
        else if (ball.testBallHitBar(players.get(1).bar)) {
            ball.changeBallDirection(players.get(1).bar.posX, 1);
        }
        else if (ball.testBallHitBar(players.get(2).bar)) {
            ball.changeBallDirection(players.get(2).bar.posX, -1);
        }
        else if (ball.testBallHitBar(players.get(3).bar)) {
            ball.changeBallDirection(players.get(3).bar.posX, -1);
        }

        if (mode == 2) {
            if (ball.testBallHitBar(players.get(0).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 0) {
                    if (lastBarTouched != -1) {
                        scoreTeamTop.scorePlayer += 1;
                    }
                    lastBarTouched = 0;
                }
            }
            else if (ball.testBallHitBar(players.get(1).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 1) {
                    if (lastBarTouched != -1) {
                        scoreTeamTop.scorePlayer += 1;
                    }
                    lastBarTouched = 1;
                }
            }
            else if (ball.testBallHitBar(players.get(2).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 2) {
                    if (lastBarTouched != -1) {
                        scoreTeamBottom.scorePlayer += 1;
                    }
                    lastBarTouched = 2;
                }
            }
            else if (ball.testBallHitBar(players.get(3).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 3) {
                    if (lastBarTouched != -1) {
                        scoreTeamBottom.scorePlayer += 1;
                    }
                    lastBarTouched = 3;
                }
            }

            if (ball.posY > posY + height) {
                scoreTeamBottom.maxScoreSecondMode = scoreTeamBottom.scorePlayer;
                scoreTeamBottom.scorePlayer = 0;
            }
            else if (ball.posY < 0) {
                scoreTeamTop.maxScoreSecondMode = scoreTeamTop.scorePlayer;
                scoreTeamTop.scorePlayer = 0;
            }
        }
    }
}