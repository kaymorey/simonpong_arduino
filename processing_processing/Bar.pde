
class Bar
{
  int initialWidth;
  int barWidth;
  int barHeight;
  int posXBar;
  int posYBar;

  int maxWidth = 300;

  Bar (int bWidth, int bHeight, int posX, int posY) {
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
  }

  void expandBar()
  {
    if (barWidth + 20 <= maxWidth) {
      barWidth += 20;
      posXBar -= 10;
    }
  }
}

