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

int blueLed = 6;
int redLed = 7;
int yellowLed = 8;
int greenLed = 9;

boolean blueLedState = LOW;
boolean redLedState = LOW;
boolean yellowLedState = LOW;
boolean greenLedState = LOW;

long previousMillis = 0;
long interval = 1000;
int currentindexSequence = 0;
boolean ledIsLighting = false;

String stringToSend;
String stringToRead = "";

int sequence[100];
int sequenceLength;
boolean sequenceNeedToBePlayed = false;
boolean stringToReadHasBeenRead = false;
boolean hasWaitedToDisplaySequence = false;
 
void setup() {
  pinMode(yellowLed, OUTPUT); // Set pin as OUTPUT
  
  // initialize serial communications at 9600 bps:
  attachInterrupt(interruptButtonLeft_0, changeState_0, FALLING);
  attachInterrupt(interruptButtonLeft_1, changeState_1, FALLING);
  pinMode(interruptButtonLeft_2, INPUT);
  pinMode(interruptButtonLeft_3, INPUT);
  Serial.begin(9600);
  
}
 
void loop() {
  unsigned long currentMillis = millis();
  
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
  
  readProcessing();
  
  if (!stringToReadHasBeenRead) {
    stringToReadHasBeenRead = true;
    if(stringToRead.length() != 0) {
      readStringToRead();
    }
    else {
      stringToReadHasBeenRead = false;
    }
  }
  
  if(sequenceNeedToBePlayed)
  {
    if(currentMillis - previousMillis > interval) {
      if(hasWaitedToDisplaySequence) {
        previousMillis = currentMillis;
        if(!ledIsLighting) {
          ledIsLighting = true;
          switch(sequence[currentindexSequence]) {
            case 0:
              blueLedState = HIGH;
              digitalWrite(blueLed, blueLedState);
              break;
            case 1:
              redLedState = HIGH;
              digitalWrite(redLed, redLedState);
              break;
            case 2:
              yellowLedState = HIGH;
              digitalWrite(yellowLed, yellowLedState);
              break;
            case 3:
              greenLedState = HIGH;
              digitalWrite(greenLed, greenLedState);
              break;
          } 
        }
        else {
          ledIsLighting = false;
          switch(sequence[currentindexSequence]) {
            case 0:
              blueLedState = LOW;
              digitalWrite(blueLed, blueLedState);
              break;
            case 1:
              redLedState = LOW;
              digitalWrite(redLed, redLedState);
              break;
            case 2:
              yellowLedState = LOW;
              digitalWrite(yellowLed, yellowLedState);
              break;
            case 3:
              greenLedState = LOW;
              digitalWrite(greenLed, greenLedState);
              break;
          }
          currentindexSequence++;
        }
        if(currentindexSequence == sequenceLength) {
          sequenceNeedToBePlayed = false;
          hasWaitedToDisplaySequence = false;
          currentindexSequence = 0;
        }
      }
      else {
        hasWaitedToDisplaySequence = true; 
      }
    }
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

void readProcessing() {
    // read data from processing
  if (Serial.available() > 0) { // If data is available to read,
    stringToRead = Serial.readStringUntil('\n'); // read it and store it in val
  }  
}

String getValue(String data, char separator, int index)
{
  int found = 0;
  int strIndex[] = {0, -1};
  int maxIndex = data.length()-1;

  for(int i=0; i<=maxIndex && found<=index; i++){
    if(data.charAt(i)==separator || i==maxIndex){
        found++;
        strIndex[0] = strIndex[1]+1;
        strIndex[1] = (i == maxIndex) ? i+1 : i;
    }
  }

  return found>index ? data.substring(strIndex[0], strIndex[1]) : "";
}

void readStringToRead() {
    sequenceLength = getValue(stringToRead, '$', 0).toInt();
    for(int i = 0; i < sequenceLength; i++) {
      sequence[i] = getValue(stringToRead, '$', i+1).toInt();
      sequenceNeedToBePlayed = true;
    }
    stringToRead = "";
    stringToReadHasBeenRead = false;
}
