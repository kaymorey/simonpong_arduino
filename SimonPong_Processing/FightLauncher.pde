
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
        text(valueToDisplay, (screenWidth - textWidth(valueToDisplay)) / 2, 3*launcherPosY + 50);

        rotate(PI);
        text(valueToDisplay, - (screenWidth + textWidth(valueToDisplay)) / 2, -launcherPosY + 50);
    }

    void displayLauncher(int currentMillis)
    {
        if(fontSize >= 200) {
            launcherNeedTowait = true;
            currentTimer = valueToDisplay;
            if(currentTimer == "3") {
                valueToDisplay = "2";
                fontSize = 0;
            }
            else if(currentTimer == "2") {
                valueToDisplay = "1";
                fontSize = 0;
            }
            else if(currentTimer == "1") {
                valueToDisplay = "FIGHT !";
                fontSize = 0;
            }
            else if(currentTimer == "FIGHT !") {
                valueToDisplay = "";
                fontSize = 0;
                pongCanBeLaunched = true;
            }
        }
        if(currentMillis - previousMillis > interval && valueToDisplay != "" && !launcherNeedTowait) {
            previousMillis = currentMillis;
            fontSize += 5;
        }
        else if(currentMillis - previousMillis > pauseInterval && launcherNeedTowait) {
            previousMillis = currentMillis;
            launcherNeedTowait = false;
        }
    }
}