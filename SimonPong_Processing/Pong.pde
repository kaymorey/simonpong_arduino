
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
        noStroke();
        fill(backgroundColor);
        rect(posX, posY, width, height);
        
        drawLine();

        switch (mode) {
            case 0 : // Pong Left
                players.get(0).draw();
                players.get(2).draw();
                break;
            case 1 : // Pong Right
                players.get(1).draw();
                players.get(3).draw();
                break;
            case 2 : // Pong Top
                players.get(0).draw();
                players.get(1).draw();
                break;
            case 3 : // Pong Bottom
                players.get(2).draw();
                players.get(3).draw();
                break;
            case 4 : // Pong Left Top - Right Bottom
                
                break;
            case 5 : // Pong Left Bottom - Right Top
                
                break;                
            default : // Pong Full
                players.get(0).draw();
                players.get(1).draw();
                players.get(2).draw();
                players.get(3).draw();
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
        balls.moveBall(width, posX);

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
        line(posX, height / 2, posX+width, height / 2);
    }
}