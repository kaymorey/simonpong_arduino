/* POT to LED test -> by Owen Mundy March 11, 2010
   from: http://itp.nyu.edu/physcomp/Labs/AnalogIn
—————————————————————*/
 
int potPinLeft = 0;    // Analog input pin that the potentiometer is attached to
int potValueLeft = 0;  // value read from the pot

int potPinRight = 1;    // Analog input pin that the potentiometer is attached to
int potValueRight = 0;  // value read from the pot

int interruptButtonLeft_0 = 0;     // interrupt is on 0 (pin 2)
int interruptButtonLeft_1 = 1;     // interrupt is on 0 (pin 3)
int interruptButtonLeft_2 = 4;     // interrupt is on 0 (pin 4)
int stateInterruptButtonLeft_2 = 0;
int interruptButtonLeft_3 = 5;     // interrupt is on 0 (pin 5)
int stateInterruptButtonLeft_3 = 0;
int state = 0;               // variable to be updated by the interrupts

String stringToSend;
 
void setup() {
  // initialize serial communications at 9600 bps:
  attachInterrupt(interruptButtonLeft_0, changeState_0, FALLING);
  attachInterrupt(interruptButtonLeft_1, changeState_1, FALLING);
  pinMode(interruptButtonLeft_2, INPUT);
  pinMode(interruptButtonLeft_3, INPUT);
  Serial.begin(9600);
}
 
void loop() {
  if (stateInterruptButtonLeft_2 == 0 && digitalRead(interruptButtonLeft_2) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_2 = 1;
  }
  else if (stateInterruptButtonLeft_2 == 1 && digitalRead(interruptButtonLeft_2) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_2 = 0;
    changeState_2();
  }
  
  if (stateInterruptButtonLeft_3 == 0 && digitalRead(interruptButtonLeft_3) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_3 = 1;
  }
  else if (stateInterruptButtonLeft_3 == 1 && digitalRead(interruptButtonLeft_3) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_3 = 0;
    changeState_3();
  }

  potValueLeft = analogRead(potPinLeft); // read the pot value
  potValueRight = analogRead(potPinRight); // read the pot value
  stringToSend = String(potValueLeft/4)+"$"+String(potValueRight/4)+"$"+String(state);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  if(state != 255) {
    state = 255;
  }
  delay(30);                     // wait 30 milliseconds before the next loop
}

void changeState_0() {
  if(state == 255) {
    state = 0; 
  }
}

void changeState_1() {
  if(state == 255) {
    state = 1;
  }
}

void changeState_2() {
  if(state == 255) {
    state = 2;
  }
}

void changeState_3() {
  if(state == 255) {
    state = 3;
  }
}
