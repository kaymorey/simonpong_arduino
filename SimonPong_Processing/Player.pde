// Bars
int barWidth = 100;
int barHeight = 20;

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

	Player(int indexPlayer)
	{
		index = indexPlayer;
		bar = new Bar(barWidth, barHeight, index);
		println(index);
	}

    void draw()
    {
        bar.draw();
    }
}