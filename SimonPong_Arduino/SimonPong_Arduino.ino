/* POT to LED test -> by Owen Mundy March 11, 2010
   from: http://itp.nyu.edu/physcomp/Labs/AnalogIn
—————————————————————*/
 
int potPinLeft = 0;    // Analog input pin that the potentiometer is attached to
int potValueLeft = 0;  // value read from the pot

int potPinRight = 1;    // Analog input pin that the potentiometer is attached to
int potValueRight = 0;  // value read from the pot

int interruptButtonLeft_0 = 0;     // interrupt is on 0 (pin 2)
int state = 0;               // variable to be updated by the interrupt

String stringToSend;
 
void setup() {
  // initialize serial communications at 9600 bps:
  attachInterrupt(interruptButtonLeft_0, changeState, FALLING);
  Serial.begin(9600);
}
 
void loop() {
  potValueLeft = analogRead(potPinLeft); // read the pot value
  potValueRight = analogRead(potPinRight); // read the pot value
  stringToSend = String(potValueLeft/4)+"$"+String(potValueRight/4)+"$"+String(state);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  delay(30);                     // wait 30 milliseconds before the next loop
}

void changeState() {
  if(state == 0) {
    state = 1; 
  }
  else {
    state = 0;
  }
}
