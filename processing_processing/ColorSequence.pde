
class ColorSequence
{
    Color[] arrayColor = new Color[4];

    int screenWidth;
    int screenHeight;
    int squareWidth;
    int squareHeight;
    int squareSpacing;

    int startingLengthSequence;
    ArrayList<Integer> sequenceToPlay = new ArrayList<Integer>();

    ColorSequence(int width, int height, int colorWidth, int colorHeight, int colorSpacing) {
        screenWidth = width;
        screenHeight = height;
        squareWidth = colorWidth;
        squareHeight = colorHeight;
        squareSpacing = colorSpacing;

        createPlayableSequence(4);

        for (int i = 0; i < arrayColor.length; i++) {
            Color colorToAdd = new Color(squareWidth, squareHeight, (screenWidth - (arrayColor.length*squareWidth + (arrayColor.length - 1)*squareSpacing))/2 + squareWidth*i + squareSpacing*i, (screenHeight - squareHeight)/2, (255/arrayColor.length)*(i+1), (255/arrayColor.length)*(i+1), (255/arrayColor.length)*(i+1), i+1);
            arrayColor[i] = colorToAdd;
        }
    }

    void drawSequence()
    {
        for (int i = 0; i < arrayColor.length; i++) {
            arrayColor[i].drawColor();
        }
    }

    void createPlayableSequence(int length) {
        startingLengthSequence = length;
        for (int i = 0; i < startingLengthSequence; i++) {
            int r = int(random(0, startingLengthSequence));
            sequenceToPlay.add(r);
        }
    }

    void playSequence() {
        // make flash the colors following th sequence
    }
}