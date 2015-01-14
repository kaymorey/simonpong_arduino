
class Bar 
{
  int barWidth;
  int barHeight;
  int posXBar;
  int posYBar;
  
  Bar(int bWidth, int bHeight, int posX, int posY) {
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
  
  void expandBar(String type)
  {
    isExpanding = true;
    barExpanding = type;
  }
}

