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
    
    int maxSpeed = 20;
    int minSpeed = 1;
    boolean controlInverted = false;

    // Bar (int bWidth, int bHeight, int posX, int posY, int speed)
    // {
    //     initialWidth = bWidth;
    //     barWidth = bWidth;
    //     barHeight = bHeight;
    //     posXBar = posX;
    //     posYBar = posY;
    //     barSpeed = speed;
    // }

    Bar (int barWidth, int barHeight, int index)
    {
        initialWidth = width;
        width = barWidth;
        height = barHeight;

        switch (index) {
            case 0:
                posX = screenWidth / 4 - barWidth / 2;
                posY = 0;
                break;
            case 1:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = 0;
                break;
            case 2:
                posX = screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                break;
            case 3:
                posX = 3 * screenWidth / 4 - barWidth / 2;
                posY = screenHeight - height;
                break;

        }
    }

    void draw()
    {
        fill(255,255,255);
        rect(posX, posY, width, height);
        //triangle(posXBar+barWidth, barHeight, posXBar+barWidth, posYBar, posXBar+barWidth+50, posYBar);
    }

    void expandBar()
    {
        if (width + 20 <= maxWidth) {
            width += 20;
            posX -= 10;
        }
    }

    void shrinkBar()
    {
        if (width - 20 >= minWidth) {
            width -= 20;
            posX += 10;
        }
    }
    
    void speedBar(boolean increase)
    {
        if (increase && (barSpeed + 5 <= maxSpeed)) {
            barSpeed += 5;
        }
        else if (!increase && (barSpeed - 5 >= minSpeed)) {
          barSpeed -= 5;
        }
    }
}