
class Ball
{
    int radiusBall;
    int posXBall;
    int posYBall;
    int incrementXBall;
    int incrementYBall;
    int[] incrementsY = {3, -3};

    Ball(int radius, int posX, int posY) {
        radiusBall = radius;
        posXBall = posX;
        posYBall = posY;
        initIncrements();
    }

    void initBall()
    {
        posXBall = (screenWidth - radiusBall)/2;
        posYBall = (screenHeight - radiusBall)/2;
        initIncrements();
    }

    void initIncrements()
    {
        incrementXBall = int(random(-4, 4));

        int index = int(random(2));
        incrementYBall = incrementsY[index];
    }

    void drawBall()
    {
        fill(255,255,255);
        ellipse(posXBall, posYBall, radiusBall, radiusBall);
    }

    void moveBall()
    {
        posXBall += incrementXBall;
        if (posXBall + radiusBall / 2 > screenWidth || posXBall - radiusBall / 2 < 0) {
            incrementXBall = -incrementXBall;
        }
        posYBall += incrementYBall;
        drawBall();
    }

    boolean testBallHitBar(Bar bar) {
        if ((posXBall + radiusBall / 2 >= bar.posX && posXBall - radiusBall / 2 <= bar.posX + bar.width) && (posYBall + radiusBall / 2 >= bar.posY && posYBall - radiusBall / 2 <= bar.posY + bar.height)) {
            // Collision
            return true;
        }
        return false;
    }

    void changeBallDirection(int posXBar, int multi) {
        // If collision with top bar multi equals 1 else multi equals -1 (ball going to top or bottom)
        switch (posBallHitBar(posXBar)) {
            case -2:
                incrementXBall = -3;
                incrementYBall = 2 * multi;
                break;
            case -1:
                incrementXBall = -2;
                incrementYBall = 2 * multi;
                break;
            case 0:
                incrementXBall = 0;
                incrementYBall = 3 * multi;
                break;
            case 1:
                incrementXBall = 2;
                incrementYBall = 2 * multi;
                break;
            case 2:
                incrementXBall = 3;
                incrementYBall = 2 * multi;
                break;
        }
    }

    int posBallHitBar (int posXBar) {
        int rangeBar = barWidth / 5;
        if (posXBall > posXBar && posXBall < posXBar + rangeBar) {
            return -2; // LEFT
        }
        else if (posXBall >= posXBar + rangeBar && posXBall < posXBar + rangeBar * 2) {
            return -1; // MIDLEFT
        }
        else if (posXBall >= posXBar + barWidth - rangeBar * 2 && posXBall < posXBar + barWidth - rangeBar) {
            return 1; // MIDRIGHT
        }
        else if (posXBall < posXBar + barWidth && posXBall >= posXBar + barWidth - rangeBar) {
            return 2; // RIGHT
        }
        return 0; // MIDDLE
    }
}
