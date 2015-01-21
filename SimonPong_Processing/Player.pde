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
    SimonResolver resolver;
    int returnedValueByResolver = 0;

    Player(Minim minim, int indexPlayer, ArrayList<Integer> sequenceToPlay)
    {
        if(indexPlayer < 2) {
            barColor = color(255);
        }
        else {
            barColor = color(200);
        }

        index = indexPlayer;
        bar = new Bar(minim, barWidth, barHeight, index, barColor);

        resolver = new SimonResolver(sequenceToPlay);
    }

    void draw()
    {
        bar.draw();
    }
}