/* POT to LED test -> by Owen Mundy March 11, 2010
   from: http://itp.nyu.edu/physcomp/Labs/AnalogIn
—————————————————————*/
 
int potPinTop = 0;    // Analog input pin that the potentiometer is attached to
int potValueTop = 0;  // value read from the pot

int potPinBottom = 1;    // Analog input pin that the potentiometer is attached to
int potValueBottom = 0;  // value read from the pot

String stringToSend;
 
void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  // declare the led pin as an output:
}
 
void loop() {
  potValueTop = analogRead(potPinTop); // read the pot value
  potValueBottom = analogRead(potPinBottom); // read the pot value
  stringToSend = String(potValueTop/4)+"$"+String(potValueBottom/4);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  delay(30);                     // wait 10 milliseconds before the next loop
}
