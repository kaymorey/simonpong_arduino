class Score {
    PFont scoreFont;
    String scoreText;
    int scorePlayer;
    //int scorePosX;
    int scorePosY;

    Score(PFont font, int score/*, int posX*/, int posY)
    {
        scoreFont = font;
        scoreText = str(score);
        scorePlayer = score;
        //scorePosX = posX;
        scorePosY = posY;
    }
    
     void displayScore()
    {
        scoreText = str(scorePlayer);
        fill(28, 28, 28);
        textFont(scoreFont);
        text(scoreText, (screenWidth - textWidth(scoreText)) / 2, scorePosY); // 50 is font-size / 2
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
