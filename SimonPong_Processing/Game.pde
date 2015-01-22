class Game {
    Sound backgroundSound;
    Sound loseSound;
    int activeScreen = 0;

    PFont pressBtnFont;
    PFont gameNameFont;

    int pressPhraseOpacity = 255;
    boolean increasePhraseOpacity = true;

    Game(Minim minim)
    {
        pressBtnFont = loadFont("BebasNeueBook-30.vlw");
        gameNameFont = loadFont("BebasNeue-100.vlw");

        backgroundSound = new Sound(minim, "arcade-music-loop.wav");
        backgroundSound.player.setGain(-6);

        loseSound = new Sound(minim, "lose.mp3");
        loseSound.player.setGain(-5);
    }

    void drawInitialScreen()
    {
        fill(251, 211, 89);
        rect(0, 0, screenWidth, screenHeight / 2);
        fill(41, 118, 174);
        rect(0, screenHeight / 2, screenWidth, screenHeight / 2);

        displayInitialScreen();
    }

    void displayInitialScreen()
    {
        String txt = "Simon";
        fill(41, 118, 174);
        textFont(gameNameFont);
        textSize(72);
        text(txt, (screenWidth - textWidth(txt)) / 2, screenHeight / 2 - 20);

        txt = "Pong";
        fill(251, 211, 89);
        textFont(gameNameFont);
        textSize(72);
        text(txt, (screenWidth - textWidth(txt)) / 2, screenHeight / 2 + 72);

        displayPressPhrase();
    }

    void displayPressPhrase()
    {
        String txt = "Press any button to play";
        fill(255, 255, 255, pressPhraseOpacity);
        textFont(pressBtnFont);
        text(txt, (screenWidth - textWidth(txt)) / 2, screenHeight - 30);

        rotate(PI);
        text(txt, - (screenWidth + textWidth(txt)) / 2, - 30);
    }
}