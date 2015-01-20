// Bars
int barWidth = 100;
int barHeight = 20;
color barColor;

//int barSpeed = 5;
//boolean increase = true;
// Bar Top
/*
int posXBarTop = (screenWidth - barWidth)/2;
int posYBarTop = 0;
// Bar Bottom
int posXBarBottom = (screenWidth - barWidth)/2;
int posYBarBottom = screenHeight - barHeight;
*/

class Player
{
    int index;
    Bar bar;

    Player(Minim minim, int indexPlayer)
    {
        if(indexPlayer < 2) {
            barColor = color(255);
        }
        else {
            barColor = color(200);
        }

        index = indexPlayer;
        bar = new Bar(minim, barWidth, barHeight, index, barColor);
    }

    void draw()
    {
        bar.draw();
    }
}