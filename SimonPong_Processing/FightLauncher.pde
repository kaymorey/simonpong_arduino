
class FightLauncher
{
    String valueToDisplay;
    PFont launcherFont = loadFont("BebasNeue-100.vlw");
    int fontSize;
    int launcherPosY;

    FightLauncher(String myString, int mySize, int posY) {
        valueToDisplay = myString;
        fontSize = mySize;
        launcherPosY = posY;
    }

    void draw() {
        fill(255, 255, 255);
        textFont(launcherFont);
        textSize(fontSize);
        text(valueToDisplay, (screenWidth - textWidth(valueToDisplay)) / 2, launcherPosY);
    }
}