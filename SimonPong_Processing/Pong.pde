
class Pong
{
    int width;
    int height;
    int posX;
    int posY;
    color backgroundColor;
    ArrayList<Player> players;
    Ball balls;
    int mode;


    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, ArrayList<Player> pongPlayers, Ball pongBalls, int pongMode) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        balls = pongBalls;
        mode = pongMode;
    }

    void draw()
    {
        size(width, height);
        background(41, 41, 41);
        drawLine();

        switch (mode) {
            case 0 :
                players.get(0).draw();
                players.get(1).draw();
                players.get(2).draw();
                players.get(3).draw();
                break;
            default :

                break;
        }

        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        */

        // Score
        if (balls.posY > height) {
            scorePlayerTop.scorePlayer += 1;
            balls.initBall();
        }
        else if (balls.posY < 0) {
            scorePlayerBottom.scorePlayer += 1;
            balls.initBall();
        }

        // Ball
        balls.moveBall();

        if (balls.testBallHitBar(players.get(0).bar)) {
            balls.changeBallDirection(players.get(0).bar.posX, 1);
        }
        else if (balls.testBallHitBar(players.get(1).bar)) {
            balls.changeBallDirection(players.get(1).bar.posX, 1);
        }
        else if (balls.testBallHitBar(players.get(2).bar)) {
            balls.changeBallDirection(players.get(2).bar.posX, -1);
        }
        else if (balls.testBallHitBar(players.get(3).bar)) {
            balls.changeBallDirection(players.get(3).bar.posX, -1);
        }
    }

    void drawLine()
    {
        stroke(28, 28, 28);
        line(0, height / 2, width, height / 2);
    }
}