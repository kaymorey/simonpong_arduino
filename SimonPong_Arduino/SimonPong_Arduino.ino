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

boolean stringToReadHasBeenRead = false;
boolean firstSequenceHasBeenDisplayed = false;
boolean firstSequenceNeedToBeDisplayed = false;
boolean isReadyToSendData = false;
boolean ledIsOn = false;
boolean canStopDemo = true;

int valueP1;
int valueP2;

int latchPin = 11;
int clockPin = 13;
int dataPin = 12;

byte dataDemo;
byte dataDemoArray[13];
boolean isOnDemo = true;
int currentIndexDemo = 0;

long previousMillis = 0;
long interval = 500;

int sequenceLength;
int sequenceP1[100];
int sequenceP2[100];
int currentIndexSequenceP1 = 0;
int currentIndexSequenceP2 = 0;
boolean sequenceNeedToBePlayedP1 = false;
boolean sequenceNeedToBePlayedP2 = false;
boolean sequenceIsPlayingP1 = false;
boolean sequenceIsPlayingP2 = false;

String stringToSend;
String stringToRead = "";
 
void setup() {
  pinMode(latchPin, OUTPUT);
  
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
  
  dataDemoArray[0] = byte(136);  //10001000
  dataDemoArray[1] = byte(68);  //01000100
  dataDemoArray[2] = byte(34);  //00100010
  dataDemoArray[3] = byte(17);  //00010001
  dataDemoArray[4] = byte(128);  //10000000
  dataDemoArray[5] = byte(64);  //01000000
  dataDemoArray[6] = byte(32);  //00100000
  dataDemoArray[7] = byte(16);  //00010000
  dataDemoArray[8] = byte(8);  //00001000
  dataDemoArray[9] = byte(4);  //00000100
  dataDemoArray[10] = byte(2); //00000010
  dataDemoArray[11] = byte(1); //00000001
  dataDemoArray[12] = byte(0); //00000000

  //function that blinks all the LEDs
  //gets passed the number of blinks and the pause time
  blinkAll_2Bytes(2,500); 
}
 
void loop() {
  unsigned long currentMillis = millis();
  
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;
    if(isOnDemo) {
      dataDemo = dataDemoArray[currentIndexDemo];
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, dataDemo);
      digitalWrite(latchPin, 1);
      if(currentIndexDemo < 12) {
        currentIndexDemo++;
      }
      else {
        currentIndexDemo = 0;
      }
    }
    else if(firstSequenceNeedToBeDisplayed && !firstSequenceHasBeenDisplayed) {
      if(ledIsOn) {
        ledIsOn = false;
        digitalWrite(latchPin, 0);
        shiftOut(dataPin, clockPin, dataDemoArray[12]);
        digitalWrite(latchPin, 1);
      }
      else {
        ledIsOn = true;
        switch(sequenceP1[currentIndexSequenceP1]) {
          case 0:
            dataDemo = dataDemoArray[0];
            break;
          case 1:
            dataDemo = dataDemoArray[1];
            break;
          case 2:
            dataDemo = dataDemoArray[2];
            break;
          case 3:
            dataDemo = dataDemoArray[3];
            break;
        }
        digitalWrite(latchPin, 0);
        shiftOut(dataPin, clockPin, dataDemo);
        digitalWrite(latchPin, 1);
        currentIndexSequenceP1++;
        currentIndexSequenceP2++;
      }
      if(currentIndexSequenceP1 >= sequenceLength) {
        firstSequenceHasBeenDisplayed = true;
        firstSequenceNeedToBeDisplayed = false;
        sequenceNeedToBePlayedP1 = false;
        sequenceNeedToBePlayedP2 = false;
      }
    }
    else if(firstSequenceHasBeenDisplayed && !isReadyToSendData) {
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, dataDemoArray[12]);
      digitalWrite(latchPin, 1);
      currentIndexSequenceP1 = 0;
      currentIndexSequenceP2 = 0;
      isReadyToSendData = true;
    }
    else if(isReadyToSendData) {
      if(sequenceNeedToBePlayedP1 && !sequenceNeedToBePlayedP2) {
            Serial.println('test');

        sequenceIsPlayingP1 = true;
        if(ledIsOn) {
          ledIsOn = false;
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemoArray[12]);
          digitalWrite(latchPin, 1);
        }
        else {
          ledIsOn = true;switch(sequenceP1[currentIndexSequenceP1]) {
            case 0:
              dataDemo = dataDemoArray[4];
              break;
            case 1:
              dataDemo = dataDemoArray[5];
              break;
            case 2:
              dataDemo = dataDemoArray[6];
              break;
            case 3:
              dataDemo = dataDemoArray[7];
              break;
          }
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemo);
          digitalWrite(latchPin, 1);
          currentIndexSequenceP1++;
        }
        if(currentIndexSequenceP1 >= sequenceLength) {
          sequenceNeedToBePlayedP1 = false;
        }
      }
      else if(sequenceNeedToBePlayedP2 && !sequenceNeedToBePlayedP1) {
        sequenceIsPlayingP2 = true;
        if(ledIsOn) {
          ledIsOn = false;
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemoArray[12]);
          digitalWrite(latchPin, 1);
        }
        else {
          ledIsOn = true;
          switch(sequenceP2[currentIndexSequenceP2]) {
            case 0:
              dataDemo = dataDemoArray[8];
              break;
            case 1:
              dataDemo = dataDemoArray[9];
              break;
            case 2:
              dataDemo = dataDemoArray[10];
              break;
            case 3:
              dataDemo = dataDemoArray[11];
              break;
          }
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemo);
          digitalWrite(latchPin, 1);
          currentIndexSequenceP2++;
        }
        if(currentIndexSequenceP2 >= sequenceLength) {
          sequenceNeedToBePlayedP2 = false;
        }
      }
      else if(sequenceNeedToBePlayedP2 && sequenceNeedToBePlayedP1) {
        sequenceIsPlayingP2 = true;
        sequenceIsPlayingP1 = true;
        if(ledIsOn) {
          ledIsOn = false;
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemoArray[12]);
          digitalWrite(latchPin, 1);
        }
        else {
          ledIsOn = true;
          int valueP1;
          int valueP2;
          
          if(3-sequenceP2[currentIndexSequenceP2] == 1 || 3-sequenceP2[currentIndexSequenceP2] == 0) {
            valueP2 = pow(2,3-sequenceP2[currentIndexSequenceP2]);
          }
          else {
            valueP2 = pow(2,3-sequenceP2[currentIndexSequenceP2])+1;
          }
          valueP1 = pow(2,7-sequenceP1[currentIndexSequenceP1])+1;
          //Serial.println(valueP1);
          
          dataDemo = byte(valueP2 + valueP1);
          digitalWrite(latchPin, 0);
          shiftOut(dataPin, clockPin, dataDemo);
          digitalWrite(latchPin, 1);
          currentIndexSequenceP2++;
          currentIndexSequenceP1++;
        }
        if(currentIndexSequenceP1 >= sequenceLength) {
          sequenceNeedToBePlayedP1 = false;
        }
        if(currentIndexSequenceP2 >= sequenceLength) {
          sequenceNeedToBePlayedP2 = false;
        }
      }
//      else if(!sequenceNeedToBePlayedP1 && sequenceIsPlayingP1 && !sequenceIsPlayingP2) {
//        sequenceIsPlayingP1 = false;
//        digitalWrite(latchPin, 0);
//        shiftOut(dataPin, clockPin, dataDemoArray[12]);
//        digitalWrite(latchPin, 1);
//        currentIndexSequenceP1 = 0;
//      }
//      else if(!sequenceNeedToBePlayedP2 && sequenceIsPlayingP2 && !sequenceIsPlayingP1) {
//        sequenceIsPlayingP2 = false;
//        digitalWrite(latchPin, 0);
//        shiftOut(dataPin, clockPin, dataDemoArray[12]);
//        digitalWrite(latchPin, 1);
//        currentIndexSequenceP2 = 0;
//      }
      else if(!sequenceNeedToBePlayedP2 && sequenceIsPlayingP2) {
        sequenceIsPlayingP2 = false;
        digitalWrite(latchPin, 0);
        shiftOut(dataPin, clockPin, dataDemoArray[12]);
        digitalWrite(latchPin, 1);
        currentIndexSequenceP2 = 0;
      }
      else if(!sequenceNeedToBePlayedP1 && sequenceIsPlayingP1) {
        sequenceIsPlayingP1 = false;
        digitalWrite(latchPin, 0);
        shiftOut(dataPin, clockPin, dataDemoArray[12]);
        digitalWrite(latchPin, 1);
        currentIndexSequenceP1 = 0;
      }
    }
  }
  readProcessing();
  
  if(isReadyToSendData || isOnDemo) {
    readInterruptLeft();
    readInterruptRight();
  }
  
  potValueLeft = analogRead(potPinLeft); // read the pot value
  potValueRight = analogRead(potPinRight); // read the pot values
  
  stringToSend = String(potValueLeft/4)+"$"+String(potValueRight/4)+"$"+String(stateLeft)+"$"+String(stateRight);
  Serial.println(stringToSend);      // print the pot value back to the debugger pane
  
  if(stateLeft != 255) {
    stateLeft = 255;
  }
  if(stateRight != 255) {
    stateRight = 255;
  }
  
  delay(30);                     // wait 30 milliseconds before the next loop
}

void readProcessing() {
    // read data from processing
  if (Serial.available() > 0) { // If data is available to read,
    stringToRead = Serial.readStringUntil('\n'); // read it and store it in val
    if(stringToRead == "stopDemo") {
      isOnDemo = false;
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, dataDemoArray[12]);
      digitalWrite(latchPin, 1);
    }
    else if(stringToRead == "firstSequence") {
      firstSequenceNeedToBeDisplayed = true;
      stringToRead = Serial.readStringUntil('\n');
      readStringToRead();
    }
    else if(isReadyToSendData) {
      readStringToRead();
    }
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
  sequenceLength = getValue(stringToRead, '$', 1).toInt();
  switch(getValue(stringToRead, '$', 0).toInt()) {
    case 0:
      for(int i = 0; i < sequenceLength; i++) {
        sequenceP1[i] = getValue(stringToRead, '$', i+2).toInt();
        sequenceP2[i] = getValue(stringToRead, '$', i+2).toInt();
        sequenceNeedToBePlayedP1 = true;
        sequenceNeedToBePlayedP2 = true;
        currentIndexSequenceP1 = 0;
        currentIndexSequenceP2 = 0;
      }
      break;
    case 1:
      for(int i = 0; i < sequenceLength; i++) {
        sequenceP1[i] = getValue(stringToRead, '$', i+2).toInt();
        sequenceNeedToBePlayedP1 = true;
        currentIndexSequenceP1 = 0;
      }
      break;
    case 2:
      for(int i = 0; i < sequenceLength; i++) {
        sequenceP2[i] = getValue(stringToRead, '$', i+2).toInt();
        sequenceNeedToBePlayedP2 = true;
        currentIndexSequenceP2 = 0;
      }
      break;
  }
  stringToRead = "";
  stringToReadHasBeenRead = true;
}

void blinkAll_2Bytes(int n, int d) {
  digitalWrite(latchPin, 0);
  shiftOut(dataPin, clockPin, 0);
  shiftOut(dataPin, clockPin, 0);
  digitalWrite(latchPin, 1);
  delay(200);
  for (int x = 0; x < n; x++) {
    digitalWrite(latchPin, 0);
    shiftOut(dataPin, clockPin, 255);
    shiftOut(dataPin, clockPin, 255);
    digitalWrite(latchPin, 1);
    delay(d);
    digitalWrite(latchPin, 0);
    shiftOut(dataPin, clockPin, 0);
    shiftOut(dataPin, clockPin, 0);
    digitalWrite(latchPin, 1);
    delay(d);
  }
}

void shiftOut(int myDataPin, int myClockPin, byte myDataOut) {
  int i=0;
  int pinState;
  pinMode(myClockPin, OUTPUT);
  pinMode(myDataPin, OUTPUT);

  digitalWrite(myDataPin, 0);
  digitalWrite(myClockPin, 0);

  for (i=7; i>=0; i--)  {
    digitalWrite(myClockPin, 0);

    if ( myDataOut & (1<<i) ) {
      pinState= 1;
    }
    else {	
      pinState= 0;
    }

    digitalWrite(myDataPin, pinState);
    digitalWrite(myClockPin, 1);
    digitalWrite(myDataPin, 0);
  }
  digitalWrite(myClockPin, 0);
}

void readInterruptLeft() {
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
}

void readInterruptRight() {
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

