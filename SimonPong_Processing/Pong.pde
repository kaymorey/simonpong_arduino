
class Pong
{
    int width;
    int height;
    int posX;
    int posY;
    color backgroundColor;
    Player[] players;
    Ball balls;
    
     
    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, Player[] pongPlayers, Ball pongBalls) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        balls = pongBalls;
    }
    
    void draw()
    {
        size(width, height);
        background(41, 41, 41);

        drawLine();

        for (int i = 0; i < nbPlayers; i++) {
            players[i].draw();
        }
        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        
        barTop.drawBar();
        barBottom.drawBar();
        */

        // Score
        if (ball.posY > height) {
            scorePlayerTop.scorePlayer += 1;
            ball.initBall();
        }
        else if (ball.posY < 0) {
            scorePlayerBottom.scorePlayer += 1;
            ball.initBall();
        }
        
        // Ball
        ball.moveBall();

        if (ball.testBallHitBar(players[0].bar)) {
            ball.changeBallDirection(players[0].bar.posX, 1);
        }
        else if (ball.testBallHitBar(players[1].bar)) {
            ball.changeBallDirection(players[1].bar.posX, -1);
        }
    }
    
    void drawLine()
    {
        stroke(28, 28, 28);
        line(0, height / 2, width, height / 2);
    }
}
