/* POT to LED test -> by Owen Mundy March 11, 2010
   from: http://itp.nyu.edu/physcomp/Labs/AnalogIn
—————————————————————*/
 
int potPinLeft = 0;    // Analog input pin that the potentiometer is attached to
int potValueLeft = 0;  // value read from the pot

int potPinRight = 1;    // Analog input pin that the potentiometer is attached to
int potValueRight = 0;  // value read from the pot

int interruptButtonLeft_0 = 9;     // interrupt is on 0 (pin 9)
int stateInterruptButtonLeft_0 = 0;
int interruptButtonLeft_1 = 8;     // interrupt is on 0 (pin 8)
int stateInterruptButtonLeft_1 = 0;
int interruptButtonLeft_2 = 7;     // interrupt is on 0 (pin 7)
int stateInterruptButtonLeft_2 = 0;
int interruptButtonLeft_3 = 6;     // interrupt is on 0 (pin 6)
int stateInterruptButtonLeft_3 = 0;
int stateLeft = 255;               // variable to be updated by the interrupts

int interruptButtonRight_0 = 5;     // interrupt is on 0 (pin 5)
int stateInterruptButtonRight_0 = 0;
int interruptButtonRight_1 = 4;     // interrupt is on 0 (pin 4)
int stateInterruptButtonRight_1 = 0;
int interruptButtonRight_2 = 3;     // interrupt is on 0 (pin 3)
int stateInterruptButtonRight_2 = 0;
int interruptButtonRight_3 = 2;     // interrupt is on 0 (pin 2)
int stateInterruptButtonRight_3 = 0;
int stateRight = 255;               // variable to be updated by the interrupts

int blueLed = 9;
int redLed = 8;
int yellowLed = 7;
int greenLed = 6;

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
  
  // player left
  pinMode(interruptButtonLeft_0, INPUT);
  pinMode(interruptButtonLeft_1, INPUT);
  pinMode(interruptButtonLeft_2, INPUT);
  pinMode(interruptButtonLeft_3, INPUT);
  
  // player right
  pinMode(interruptButtonRight_0, INPUT);
  pinMode(interruptButtonRight_1, INPUT);
  pinMode(interruptButtonRight_2, INPUT);
  pinMode(interruptButtonRight_3, INPUT);
  
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  
}
 
void loop() {
  unsigned long currentMillis = millis();
  
  // player left
  if (stateInterruptButtonLeft_0 == 0 && digitalRead(interruptButtonLeft_0) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_0 = 1;
  }
  else if (stateInterruptButtonLeft_0 == 1 && digitalRead(interruptButtonLeft_0) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_0 = 0;  
    changeStateLeft_0();
  }
  
  if (stateInterruptButtonLeft_1 == 0 && digitalRead(interruptButtonLeft_1) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_1 = 1;
  }
  else if (stateInterruptButtonLeft_1 == 1 && digitalRead(interruptButtonLeft_1) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_1 = 0;  
    changeStateLeft_1();
  }
  
  if (stateInterruptButtonLeft_2 == 0 && digitalRead(interruptButtonLeft_2) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_2 = 1;
  }
  else if (stateInterruptButtonLeft_2 == 1 && digitalRead(interruptButtonLeft_2) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_2 = 0;  
    changeStateLeft_2();
  }
  
  if (stateInterruptButtonLeft_3 == 0 && digitalRead(interruptButtonLeft_3) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonLeft_3 = 1;
  }
  else if (stateInterruptButtonLeft_3 == 1 && digitalRead(interruptButtonLeft_3) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonLeft_3 = 0;
    changeStateLeft_3();
  }
  
  // player Right
  if (stateInterruptButtonRight_0 == 0 && digitalRead(interruptButtonRight_0) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonRight_0 = 1;
  }
  else if (stateInterruptButtonRight_0 == 1 && digitalRead(interruptButtonRight_0) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonRight_0 = 0;  
    changeStateRight_0();
  }
  
  if (stateInterruptButtonRight_1 == 0 && digitalRead(interruptButtonRight_1) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonRight_1 = 1;
  }
  else if (stateInterruptButtonRight_1 == 1 && digitalRead(interruptButtonRight_1) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonRight_1 = 0;  
    changeStateRight_1();
  }
  
  if (stateInterruptButtonRight_2 == 0 && digitalRead(interruptButtonRight_2) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonRight_2 = 1;
  }
  else if (stateInterruptButtonRight_2 == 1 && digitalRead(interruptButtonRight_2) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonRight_2 = 0;  
    changeStateRight_2();
  }
  
  if (stateInterruptButtonRight_3 == 0 && digitalRead(interruptButtonRight_3) == 1) {
    // on appuie sur le bouton pour la première fois
    stateInterruptButtonRight_3 = 1;
  }
  else if (stateInterruptButtonRight_3 == 1 && digitalRead(interruptButtonRight_3) == 0) {
    // on a retiré le doigt du bouton
    stateInterruptButtonRight_3 = 0;
    changeStateRight_3();
  }

  potValueLeft = analogRead(potPinLeft); // read the pot value
  potValueRight = analogRead(potPinRight); // read the pot value
  stringToSend = String(potValueLeft/4)+"$"+String(potValueRight/4)+"$"+String(stateLeft)+"$"+String(stateRight);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  if(stateLeft != 255) {
    stateLeft = 255;
  }
  
  if(stateRight != 255) {
    stateRight = 255;
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

// player Left
void changeStateLeft_0() {
  if(stateLeft == 255) {
    stateLeft = 0; 
  }
}

void changeStateLeft_1() {
  if(stateLeft == 255) {
    stateLeft = 1;
  }
}

void changeStateLeft_2() {
  if(stateLeft == 255) {
    stateLeft = 2;
  }
}

void changeStateLeft_3() {
  if(stateLeft == 255) {
    stateLeft = 3;
  }
}

// player Right
void changeStateRight_0() {
  if(stateRight == 255) {
    stateRight = 0; 
  }
}

void changeStateRight_1() {
  if(stateRight == 255) {
    stateRight = 1;
  }
}

void changeStateRight_2() {
  if(stateRight == 255) {
    stateRight = 2;
  }
}

void changeStateRight_3() {
  if(stateRight == 255) {
    stateRight = 3;
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
