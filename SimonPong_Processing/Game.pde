class Game {
    Sound backgroundSound;
    Sound loseSound;

    Game(Minim minim)
    {
        backgroundSound = new Sound(minim, "arcade-music-loop.wav");
        backgroundSound.player.setGain(-6);

        loseSound = new Sound(minim, "lose.mp3");
    }
}