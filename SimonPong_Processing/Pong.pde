
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
                play(players.get(0), players.get(2), balls);
                break;
            case 1 : // Pong Right
                play(players.get(1), players.get(3), balls);
                break;
            case 2 : // Pong Top
                play(players.get(0), players.get(1), balls);
                break;
            case 3 : // Pong Bottom
                play(players.get(2), players.get(3), balls);
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
    }

    void drawLine()
    {
        stroke(28, 28, 28);
        line(posX, height / 2, posX+width, height / 2);
    }

    void play(Player playerTop, Player playerBottom, Ball ball)
    {
        playerTop.draw();
        playerBottom.draw();

        // Score
        if (ball.posY > height) {
            //scorePlayerTop.scorePlayer += 1;
            ball.initBall();
        }
        else if (ball.posY < 0) {
            //scorePlayerBottom.scorePlayer += 1;
            ball.initBall();
        }

        // Ball
        ball.moveBall(width, posX);

        if (ball.testBallHitBar(playerTop.bar)) {
            ball.changeBallDirection(playerTop.bar.posX, 1);
        }
        else if (ball.testBallHitBar(playerBottom.bar)) {
            ball.changeBallDirection(playerBottom.bar.posX, -1);
        }
    }
}