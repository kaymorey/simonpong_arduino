class Bar
{
    int initialWidth;
    int barWidth;
    int barHeight;
    int posXBar;
    int posYBar;

    int maxWidth = 300;
    int minWidth = 60;

    boolean controlInverted = false;

    Bar (int bWidth, int bHeight, int posX, int posY)
    {
        initialWidth = bWidth;
        barWidth = bWidth;
        barHeight = bHeight;
        posXBar = posX;
        posYBar = posY;
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
}

