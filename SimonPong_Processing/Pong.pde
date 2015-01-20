
class Pong
{
    int width;
    int height;
    int posX;
    int posY;
    color backgroundColor;
    ArrayList<Player> players;
    Ball ball;
    int mode;


    Pong(int pongWidth, int pongHeight, int pongPosX, int pongPosY, color pongBackground, ArrayList<Player> pongPlayers, Ball pongBall, int pongMode) {
        width = pongWidth;
        height = pongHeight;
        posX = pongPosX;
        posY = pongPosY;
        backgroundColor = pongBackground;
        players = pongPlayers;
        ball = pongBall;
        mode = pongMode;
    }

    void draw()
    {
        drawBackground();
        drawLine();
        play();

        /*
        scorePlayerTop.displayScore();
        scorePlayerBottom.displayScore();
        */
    }

    void drawBackground()
    {
        noStroke();
        fill(backgroundColor, 80);
        rect(posX, posY, width, height);
    }

    void drawLine()
    {
        float redColor = red(backgroundColor)-30;
        float greenColor = green(backgroundColor)-30;
        float blueColor = blue(backgroundColor)-30;

        stroke(redColor, greenColor, blueColor);
        line(posX, posY + height / 2, posX+width, posY + height / 2);
    }

    void play()
    {
        players.get(0).draw();
        players.get(1).draw();
        players.get(2).draw(); 
        players.get(3).draw();

        // Score
        if (ball.posY > posY + height) {
            //scorePlayerTop.scorePlayer += 1;
            ball.initBall();
        }
        else if (ball.posY < 0) {
            //scorePlayerBottom.scorePlayer += 1;
            ball.initBall();
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
    }
}