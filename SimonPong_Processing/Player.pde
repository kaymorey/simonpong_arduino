/////////
// Bar //
/////////
int barWidth = 100;
int barHeight = 20;
color barColor;
//int barSpeed = 5;
//boolean increase = true;

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