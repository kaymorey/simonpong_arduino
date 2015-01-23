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

     void display(int pongPosX, int pongWidth, boolean rotate)
    {
        scoreText = str(scorePlayer);

        float redColor = red(scoreColor)-30;
        float greenColor = green(scoreColor)-30;
        float blueColor = blue(scoreColor)-30;

        fill(redColor, greenColor, blueColor);
        textFont(scoreFont);

        if (rotate) {
            rotate(PI);
            text(scoreText, - pongPosX - (pongWidth + textWidth(scoreText)) / 2, - scorePosY + 35);
            rotate(-PI);
        }
        else {
            text(scoreText, pongPosX + (pongWidth - textWidth(scoreText)) / 2, scorePosY + 35);
        }
    }
}