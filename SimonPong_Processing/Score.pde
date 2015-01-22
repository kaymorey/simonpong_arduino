class Score {
    PFont scoreFont = loadFont("BebasNeue-100.vlw");
    String scoreText;
    int scorePlayer;
    int scorePosY;
    int maxScoreSecondMode;
    color scoreColor;

    Score(int score, int posY, color sColor)
    {
        scoreText = str(score);
        scorePlayer = score;
        scorePosY = posY;
        scoreColor = sColor;
    }

     void display(int pongPosX, int pongWidth)
    {
        scoreText = str(scorePlayer);

        float redColor = red(scoreColor)-30;
        float greenColor = green(scoreColor)-30;
        float blueColor = blue(scoreColor)-30;

        fill(redColor, greenColor, blueColor);
        textFont(scoreFont);
        text(scoreText, pongPosX + (pongWidth - textWidth(scoreText)) / 2, scorePosY + 35); // 50 is font-size / 2
    }
/*
    void displayTopScore()
    {
        String s = str(topScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight / 4 + 50); // 50 is font-size / 2
    }

    void displayBottomScore()
    {
        String s = str(bottomScore);
        fill(28, 28, 28);
        textFont(loadFont("BebasNeue-100.vlw"));
        text(s, (screenWidth - textWidth(s)) / 2, screenHeight - (screenHeight / 4 - 50)); // 50 is font-size / 2
    }
*/
}