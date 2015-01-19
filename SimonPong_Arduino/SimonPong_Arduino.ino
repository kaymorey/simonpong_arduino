/* POT to LED test -> by Owen Mundy March 11, 2010
   from: http://itp.nyu.edu/physcomp/Labs/AnalogIn
—————————————————————*/
 
int potPinLeft = 0;    // Analog input pin that the potentiometer is attached to
int potValueLeft = 0;  // value read from the pot

int potPinRight = 1;    // Analog input pin that the potentiometer is attached to
int potValueRight = 0;  // value read from the pot

const int buttonPinLeft_1 = 8;     // the number of the pushbutton pin
const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonLeftState_1 = 0;         // variable for reading the pushbutton status

String stringToSend;
 
void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  // declare the led pin as an output:
}
 
void loop() {
  potValueLeft = analogRead(potPinLeft); // read the pot value
  potValueRight = analogRead(potPinRight); // read the pot value
  buttonLeftValue_1 = digitalRead(buttonPinLeft_1);
  stringToSend = String(potValueLeft/4)+"$"+String(potValueRight/4);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  delay(30);                     // wait 10 milliseconds before the next loop
}
