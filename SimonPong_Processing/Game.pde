class Game {
    Sound backgroundSound;
    Sound loseSound;
    int activeScreen = 0;

    Game(Minim minim)
    {
        backgroundSound = new Sound(minim, "arcade-music-loop.wav");
        backgroundSound.player.setGain(-6);

        loseSound = new Sound(minim, "lose.mp3");
    }

    void drawInitialScreen()
    {
        fill(41, 118, 174);
        rect(0, 0, screenWidth, screenHeight / 2);
        fill(251, 211, 89);
        rect(0, screenHeight / 2, screenWidth, screenHeight / 2);
    }
}