class Game {
    Sound backgroundSound;
    Sound loseSound;
    int activeScreen = 0;

    PFont pressBtnFont;
    PFont gameNameFont;

    int pressPhraseOpacity = 255;
    boolean increasePhraseOpacity = true;

    boolean end;

    Game(Minim minim)
    {
        pressBtnFont = loadFont("BebasNeueBook-30.vlw");
        gameNameFont = loadFont("BebasNeue-100.vlw");

        backgroundSound = new Sound(minim, "arcade-music-loop.wav");
        backgroundSound.player.setGain(-6);

        loseSound = new Sound(minim, "lose3.mp3");
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

    void drawTimesUpPhrase()
    {
        String txt = "Time's up !";
        fill(255, 255, 255);
        textFont(gameNameFont);
        textSize(65);
        text (txt, (screenWidth - textWidth(txt)) / 2, screenHeight / 2 + 33);
    }

    void drawWiningTeamPhrase(String txt)
    {
        fill(255, 255, 255);
        textFont(gameNameFont);
        textSize(65);
        text (txt, (screenWidth - textWidth(txt)) / 2, screenHeight / 2 + 33);
    }

    void drawLastScreen()
    {
        fill(251, 211, 89);
        rect(0, 0, screenWidth, screenHeight / 2);
        fill(41, 118, 174);
        rect(0, screenHeight / 2, screenWidth, screenHeight / 2);

        displayLastScreen();
    }

    void displayLastScreen()
    {
        String textTop;
        String textBottom;

        if (nbRoundsWinOne > nbRoundsWinTwo) {
            textTop = "You win !";
            textBottom = "You lose !";
        }
        else if (nbRoundsWinOne < nbRoundsWinTwo) {
            textTop = "You lose !";
            textBottom = "You win !";
        }
        else {
            textTop = "Draw";
            textBottom = "Draw";
        }

        fill(251, 211, 89);
        textFont(gameNameFont);
        textSize(72);
        text(textBottom, (screenWidth - textWidth(textBottom)) / 2, screenHeight / 2 + 72);

        rotate(PI);
        fill(41, 118, 174);
        textFont(gameNameFont);
        textSize(72);
        text(textTop, - (screenWidth + textWidth(textTop)) / 2, - screenHeight / 2 + 72);
    }
}