
class Simon
{
    ArrayList<Color> availableColors = new ArrayList<Color>();
    ArrayList<Integer> sequenceToPlay = new ArrayList<Integer>();

    Simon(int numberOfItems, int numberOfLeds) {
        for (int i = 0; i < numberOfLeds; i++) {
            Color colorToAdd = new Color(i);
            availableColors.add(colorToAdd);
        }
        for (int i = 0; i < numberOfItems; i++) {
            int randomValue = int(random(0, availableColors.size()));
            sequenceToPlay.add(availableColors.get(randomValue).identifier);
        }
    }

    void play() {
        for (int i = 0; i < sequenceToPlay.size(); i++) {
            println("sequenceToPlay["+i+"] = "+sequenceToPlay.get(i));
        }
    }

    void win(int player) {
        println("PLAYER "+str(player)+" WIN !!");
    }
}