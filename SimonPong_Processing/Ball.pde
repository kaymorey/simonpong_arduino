
class Ball
{
    int radius;
    int posX;
    int posY;
    int incrementX;
    int incrementY;
    int[] incrementsY = {3, -3};

    Ball(int radiusBall, int posXBall, int posYBall) {
        radius = radiusBall;
        posX = posXBall;
        posY = posYBall;
        initIncrements();
    }

    void initBall()
    {
        posX = (screenWidth - radius)/2;
        posY = (screenHeight - radius)/2;
        initIncrements();
    }

    void initIncrements()
    {
        incrementX = int(random(-4, 4));

        int index = int(random(2));
        incrementY = incrementsY[index];
    }

    void drawBall()
    {
        fill(255,255,255);
        ellipse(posX, posY, radius, radius);
    }

    void moveBall()
    {
        posX += incrementX;
        if (posX + radius / 2 > screenWidth || posX - radius / 2 < 0) {
            incrementX = -incrementX;
        }
        posY += incrementY;
        drawBall();
    }

    boolean testBallHitBar(Bar bar) {

        if ((posX + radius / 2 >= bar.posX && posX - radius / 2 <= bar.posX + bar.width) && (posY + radius / 2 >= bar.posY && posY - radius / 2 <= bar.posY + bar.height)) {
            // Collision
            return true;
        }
        return false;
    }

    void changeBallDirection(int posXBar, int multi) {
        // If collision with top bar multi equals 1 else multi equals -1 (ball going to top or bottom)
        switch (posBallHitBar(posXBar)) {
            case -2:
                incrementX = -3;
                incrementY = 2 * multi;
                break;
            case -1:
                incrementX = -2;
                incrementY = 2 * multi;
                break;
            case 0:
                incrementX = 0;
                incrementY = 3 * multi;
                break;
            case 1:
                incrementX = 2;
                incrementY = 2 * multi;
                break;
            case 2:
                incrementX = 3;
                incrementY = 2 * multi;
                break;
        }
    }

    int posBallHitBar (int posXBar) {
        int rangeBar = barWidth / 5;
        if (posX > posXBar && posX < posXBar + rangeBar) {
            return -2; // LEFT
        }
        else if (posX >= posXBar + rangeBar && posX < posXBar + rangeBar * 2) {
            return -1; // MIDLEFT
        }
        else if (posX >= posXBar + barWidth - rangeBar * 2 && posX < posXBar + barWidth - rangeBar) {
            return 1; // MIDRIGHT
        }
        else if (posX < posXBar + barWidth && posX >= posXBar + barWidth - rangeBar) {
            return 2; // RIGHT
        }
        return 0; // MIDDLE
    }
}