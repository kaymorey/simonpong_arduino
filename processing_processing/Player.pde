class Player
{
	int index;
	Bar bar;

	Player(int indexPlayer, Bar playerBar)
	{
		index = indexPlayer;
		bar = playerBar;
	}

        void draw()
        {
              bar.draw();
        }
}
