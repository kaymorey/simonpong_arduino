class Bar
{
    int initialWidth;
    int barWidth;
    int barHeight;
    int posXBar;
    int posYBar;
    int barSpeed;

    int maxWidth = 300;
    int minWidth = 60;
    
    int maxSpeed = 20;
    int minSpeed = 1;
    boolean controlInverted = false;

    Bar (int bWidth, int bHeight, int posX, int posY, int speed)
    {
        initialWidth = bWidth;
        barWidth = bWidth;
        barHeight = bHeight;
        posXBar = posX;
        posYBar = posY;
        barSpeed = speed;
    }

    void drawBar()
    {
        fill(255,255,255);
        rect(posXBar, posYBar, barWidth, barHeight);
        //triangle(posXBar+barWidth, barHeight, posXBar+barWidth, posYBar, posXBar+barWidth+50, posYBar);
    }

    void expandBar()
    {
        if (barWidth + 20 <= maxWidth) {
            barWidth += 20;
            posXBar -= 10;
        }
    }

    void shrinkBar()
    {
        if (barWidth - 20 >= minWidth) {
            barWidth -= 20;
            posXBar += 10;
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