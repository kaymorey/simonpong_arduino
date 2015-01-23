
class Bar
{
    int posX;
    int posY;
    int barSpeed;

    int initialWidth;
    int width;
    int height;
    int maxWidth = 300;
    int minWidth = 60;
    color bColor;

    int maxSpeed = 20;
    int minSpeed = 1;
    boolean controlInverted = false;

    Sound sound;

    // Bar (int bWidth, int bHeight, int posX, int posY, int speed)
    // {
    //     initialWidth = bWidth;
    //     barWidth = bWidth;
    //     barHeight = bHeight;
    //     posXBar = posX;
    //     posYBar = posY;
    //     barSpeed = speed;
    // }

    Bar (Minim minim, int barWidth, int barHeight, int index, color barColor)
    {
        initialWidth = width;
        width = barWidth;
        height = barHeight;
        bColor = barColor;

        switch (index) {
            case 0:
                posX = screenWidth / 4 - barWidth / 2;
                posY = 0;
                sound = new Sound(minim, "bar1.mp3");
                break;
            case 1:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = 0;
                sound = new Sound(minim, "bar1.mp3");
                break;
            case 2:
                posX = screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                sound = new Sound(minim, "bar2.mp3");
                break;
            case 3:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                sound = new Sound(minim, "bar2.mp3");
                break;
            default :
                posX = 0;
                posY = 0;
                break;
        }
    }

    void draw()
    {
        noStroke();
        fill(bColor);
        smooth();
        rect(posX, posY, width, height);
        //triangle(posXBar+barWidth, barHeight, posXBar+barWidth, posYBar, posXBar+barWidth+50, posYBar);
    }

    void expand()
    {
        if (width + 20 <= maxWidth) {
            width += 20;
            posX -= 10;
        }
    }

    void shrink()
    {
        if (width - 20 >= minWidth) {
            width -= 20;
            posX += 10;
        }
    }

    void reverse(boolean controlInverted)
    {
        if (!controlInverted && posX > 0) {
            posX -= 5;
        }
        else if (controlInverted && posX < screenWidth / 2 - width) {
            posX += 5;
        }
    }

    void speed(boolean increase)
    {
        if (increase && (barSpeed + 5 <= maxSpeed)) {
            barSpeed += 5;
        }
        else if (!increase && (barSpeed - 5 >= minSpeed)) {
          barSpeed -= 5;
        }
    }
}