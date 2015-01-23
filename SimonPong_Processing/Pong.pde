//////////
// Ball //
//////////
int radiusBall = 20;
int posXBall;
int posYBall;

///////////
// Score //
///////////
int posYScoreTeamOne;
int posYScoreTeamTwo;

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
    Score scoreTeamOne;
    Score scoreTeamTwo;
    int mode;
    int lastBarTouched = -1;
    boolean firstDisplay = true;

    Pong(Game pongGame, int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, ArrayList<Player> pongPlayers, int pongMode) {

        game = pongGame;
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        mode = pongMode;

        posYScoreTeamOne = height / 4;
        posYScoreTeamTwo = 3 * (height / 4);

        switch (mode) {
            case 0 : // Pong Left
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 2;
                break;
            case 1 : // Pong Right
                posXBall = 3 * (screenWidth / 4);
                posYBall = screenHeight / 2;
                break;
            case 2 : // Pong Top
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 4;
                posYScoreTeamOne = height / 2;
                break;
            case 3 : // Pong Bottom
                posXBall = 3 * (screenWidth / 4);
                posYBall = 3 * (screenHeight / 4);
                posYScoreTeamOne = posY + (height / 2);
                break;
            case 4 : // Pong Diagonal TLBR
                posXBall = screenWidth / 4;
                posYBall = screenHeight / 2 - 50;

                    posYScoreTeamOne = height / 4;
                    posYScoreTeamTwo = 3 * (height / 4);

                backgroundColor2 = color(41, 118, 174);
                break;
            case 5 : // Pong Diagonal TRBL
                posXBall = 3 * (screenWidth / 4);
                posYBall = screenHeight / 2 - 50;

                    posYScoreTeamOne = height / 4;
                    posYScoreTeamTwo = 3 * (height / 4);

                backgroundColor2 = color(238, 148, 39);
                break;
            default : // Pong Full
                posXBall = screenWidth / 2;
                posYBall = screenHeight / 2;
                break;
        }

        ball = new Ball(radiusBall, posXBall, posYBall);
        scoreTeamOne = new Score(0, posYScoreTeamOne, backgroundColor);

        if(mode != 2 && mode != 3) {
            scoreTeamTwo = new Score(0, posYScoreTeamTwo, backgroundColor);
        }

        drawBackground(255);
    }

    void draw()
    {
        if (firstDisplay) {
            levelTimer = millis();
            firstDisplay = false;
        }
        drawBackground(80);
        drawLine();
        if (pongCanBeLaunched) {
            drawScore();
        }
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

        if(mode == 2 || mode == 3) {
            line(posX + width / 2, posY, posX + width / 2, posY + height);
        }
        else {
            line(posX, posY + height / 2, posX + width, posY + height / 2);
        }
    }

    void drawPlayer()
    {
        players.get(0).draw();
        players.get(1).draw();
        players.get(2).draw();
        players.get(3).draw();
    }

    void drawScore()
    {
        int teamOnePosX = posX;
        int teamTwoPosX = posX;
        int playerWidth = width;
        boolean rotateOne = true;
        boolean rotateTwo = false;

        if (mode == 3) {
            rotateOne = false;
        }
        else if(mode == 4) {
            playerWidth = playerWidth / 2;
            //teamOnePosX = playerWidth;
            teamTwoPosX = playerWidth;
        }
        else if (mode == 5) {
            playerWidth = playerWidth / 2;
            teamOnePosX = playerWidth;
            //teamTwoPosX = playerWidth;
        }

        scoreTeamOne.display(teamOnePosX, playerWidth, rotateOne);

        if(mode != 2 && mode != 3) {
            scoreTeamTwo.display(teamTwoPosX, playerWidth, rotateTwo);
        }
    }

    void play()
    {
        // Score
        if (ball.posY > posY + height) {
            game.loseSound.player.play();
            ball.initBall();
            game.loseSound.player.rewind();

            if (mode != 2 && mode != 3) {
                scoreTeamOne.scorePlayer += 1;
            }
        }
        else if (ball.posY < 0) {
            game.loseSound.player.play();
            ball.initBall();
            game.loseSound.player.rewind();

            if (mode != 2 && mode != 3) {
                scoreTeamTwo.scorePlayer += 1;
            }
        }

        // Ball
        if(ball.loadingEnd) {
            ball.moveBall(width, height, posX, posY, mode);
        }
        else {
            ball.loading();
        }


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

        if (mode == 2 || mode == 3) {
            if (ball.testBallHitBar(players.get(0).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 0) {
                    if (lastBarTouched != -1) {
                        scoreTeamOne.scorePlayer += 1;
                    }
                    lastBarTouched = 0;
                }
            }
            else if (ball.testBallHitBar(players.get(1).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 1) {
                    if (lastBarTouched != -1) {
                        scoreTeamOne.scorePlayer += 1;
                    }
                    lastBarTouched = 1;
                }
            }
            else if (ball.testBallHitBar(players.get(2).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 2) {
                    if (lastBarTouched != -1) {
                        scoreTeamOne.scorePlayer += 1;
                    }
                    lastBarTouched = 2;
                }
            }
            else if (ball.testBallHitBar(players.get(3).bar)) {
                if (lastBarTouched == -1 || lastBarTouched != 3) {
                    if (lastBarTouched != -1) {
                        scoreTeamOne.scorePlayer += 1;
                    }
                    lastBarTouched = 3;
                }
            }

            if (ball.posY > posY + height || ball.posY < 0) {
                scoreTeamOne.maxScoreSecondMode = scoreTeamOne.scorePlayer;
                scoreTeamOne.scorePlayer = 0;
            }
            /*
            else if (ball.posY < 0) {
                scoreTeamOne.maxScoreSecondMode = scoreTeamOne.scorePlayer;
                scoreTeamOne.scorePlayer = 0;
            }*/
        }
    }
}