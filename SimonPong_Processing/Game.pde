class Game {
    Sound backgroundSound;
    Sound loseSound;
    int activeScreen = 0;

    PFont pressBtnFont;

    Game(Minim minim)
    {
        pressBtnFont = loadFont("BebasNeueBook-30.vlw");

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

        displayInitialScreen();
    }

    void displayInitialScreen()
    {
        println("display text");
        String txt = "Press any button to play";
        fill(255);
        textSize(32);
        text(txt, 10, 30);
        // String txt = "Press any button to play";
        // fill(255);
        // textFont(pressBtnFont);
        // text(txt, (screenWidth - textWidth(txt)) / 2, 0);
    }
}