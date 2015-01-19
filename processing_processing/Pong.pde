
class Pong
{
    int width;
    int height;
    int posX;
    int posY;
    color backgroundColor;
    ArrayList<Player> players;
    
     
    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, ArrayList<Player> pongPlayers, Ball[] pongBalls) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        balls = pongBalls;
    }
    
    void drawPong()
    {
        size(width, height);
        background(41, 41, 41);

        drawLine();

        for(int i : players) {
            players.get(i).draw();
        }
        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        
        barTop.drawBar();
        barBottom.drawBar();
        */

        // Score
        if (ball.posYBall > height) {
            scorePlayerTop.scorePlayer += 1;
            ball.initBall();
        }
        else if (ball.posYBall < 0) {
            scorePlayerBottom.scorePlayer += 1;
            ball.initBall();
        }
        
        // Ball
        ball.moveBall();

        if (ball.testBallHitBar(barTop)) {
            ball.changeBallDirection(barTop.posXBar, 1);
        }
        else if (ball.testBallHitBar(barBottom)) {
            ball.changeBallDirection(barBottom.posXBar, -1);
        }
    }
    
    void drawLine()
    {
        stroke(28, 28, 28);
        line(0, height / 2, width, height / 2);
    }
}
