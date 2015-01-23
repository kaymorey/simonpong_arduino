
class Ball
{
    int radius;
    int initialPosX;
    int initialPosY;
    int posX;
    int posY;
    int incrementX;
    int incrementY;
    int[] incrementsY = {10, -10};

    int counter;

    boolean transparentMalus;
    boolean isTransparent;
    boolean ballAtTheTop = true;

    int timer = 0;
    int maxTimer;
    boolean loadingEnd = false;

    Ball(int radiusBall, int initialPosXBall, int initialPosYBall) {
        radius = radiusBall;
        initialPosX = initialPosXBall;
        initialPosY = initialPosYBall;
        posX = initialPosXBall;
        posY = initialPosYBall;
        initIncrements();
    }

    void initBall()
    {
        ballAtTheTop = true;
        loadingEnd = false;

        posX = initialPosX;
        posY = initialPosY;
        initIncrements();
    }

    void loading()
    {
        drawBall();

        noFill();
        stroke(255, 100);

        if(timer < maxTimer) {
            arc(initialPosX, initialPosY, 3*radius, 3*radius, -(2*PI)/4, timer*(2*PI)/maxTimer-(2*PI)/4);
        }
        else {
            timer = 0;
            loadingEnd = true;
        }

        timer++;
    }

    void initIncrements()
    {
        incrementX = int(random(-4, 4));

        int index = int(random(2));
        incrementY = incrementsY[index];
    }

    void drawBall()
    {
        noStroke();

        if (!isTransparent) {
            fill(255,255,255);
            smooth();
        }
        else {
            fill(255,255,255, 0);
        }

        ellipse(posX, posY, radius, radius);

        if (!pongCanBeLaunched) {
            maxTimer = 210;
        }
        else {
            maxTimer = 100;
        }
    }

    void moveBall(int pongWidth, int pongHeight, int pongPosX, int pongPosY, int mode)
    {
        if (transparentMalus) {
            if (counter == 30) {
                counter = 1;
                isTransparent = !isTransparent;
            }
            else {
                counter++;
            }
        }

        posX += incrementX;

        if ((posX + radius / 2 > pongPosX + pongWidth) || (posX - radius / 2 < pongPosX)) {
            incrementX = -incrementX;
        }
        else if ((mode == 4) && (posX + radius / 2 > pongWidth / 2) && (posY - radius / 2 < pongHeight / 2)) {

            if (!ballAtTheTop) {
                posX = posX - pongWidth / 2;
                ballAtTheTop = true;
            }
            else {
                incrementX = -incrementX;
            }
        }
        else if ((mode == 4) && (posX - radius / 2 < pongWidth / 2) && (posY + radius / 2 > pongHeight / 2)) {

            if (ballAtTheTop) {
                posX = posX + pongWidth / 2;
                ballAtTheTop = false;
            }
            else {
                incrementX = -incrementX;
            }
        }
        else if ((mode == 5) && (posX + radius / 2 > pongWidth / 2) && (posY + radius / 2 > pongHeight / 2)) {

            if (ballAtTheTop) {
                posX = posX - pongWidth / 2;
                ballAtTheTop = false;
            }
            else {
                incrementX = -incrementX;
            }
        }
        else if ((mode == 5) && (posX - radius / 2 < pongWidth / 2) && (posY - radius / 2 < pongHeight / 2)) {

            if (!ballAtTheTop) {
                posX = posX + pongWidth / 2;
                ballAtTheTop = true;
            }
            else {
                incrementX = -incrementX;
            }
        }

        posY += incrementY;

        if ((mode == 2 && (posY + radius / 2 > pongPosY + pongHeight)) || (mode == 3 && (posY - radius / 2 < pongPosY))) {
            incrementY = -incrementY;
        }

        drawBall();
    }

    boolean testBallHitBar(Bar bar) {

        if ((posX + radius / 2 >= bar.posX && posX - radius / 2 <= bar.posX + bar.width) && (posY + radius / 2 >= bar.posY && posY - radius / 2 <= bar.posY + bar.height)) {
            bar.sound.player.play();
            bar.sound.player.rewind();
            // Collision
            return true;
        }
        return false;
    }

    void changeBallDirection(int posXBar, int multi) {
        // If collision with top bar multi equals 1 else multi equals -1 (ball going to top or bottom)
        switch (posBallHitBar(posXBar)) {
            case -2:
                incrementX = -5;
                incrementY = 8 * multi;
                break;
            case -1:
                incrementX = -3;
                incrementY = 8 * multi;
                break;
            case 0:
                incrementX = 0;
                incrementY = 10 * multi;
                break;
            case 1:
                incrementX = 3;
                incrementY = 8 * multi;
                break;
            case 2:
                incrementX = 5;
                incrementY = 8 * multi;
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