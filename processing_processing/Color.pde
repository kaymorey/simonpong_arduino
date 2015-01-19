
class Color
{
    int widthSquare;
    int heightSquare;
    int posXSquare;
    int posYSquare;
    int redValue;
    int greenValue; 
    int blueValue;
    int identifier;

    Color(int width, int height, int posX, int posY, int red, int green, int blue, int identifierValue) {
        widthSquare = width;
        heightSquare = height;
        posXSquare = posX;
        posYSquare = posY;
        redValue = red;
        greenValue = green;
        blueValue = blue;
        identifier = identifierValue;
    }

    void drawColor()
    {
        fill(redValue,greenValue,blueValue);
        rect(posXSquare, posYSquare, widthSquare, heightSquare);
    }

    void tiltColor()
    {

    }

}