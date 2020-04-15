/*
  ESP32ToProcessing
  by Alvin Tran
  Get data from ESP32 to manipulate a sketch in Processing
 */

int ledPin=15;
int buttonPin=12;
int LDRPin=A2;

//-- analog values, track for formatting to serial
int switchValue=0;
int sensorValue=0;

//-- time between LED flashes, for startup
const int ledFlashDelay=150;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize pins and input and output
  pinMode(ledPin, OUTPUT);//LED light    
  
  pinMode(buttonPin, INPUT);//Switch
  pinMode(LDRPin, INPUT);//LDR   
  
  Serial.begin(115200);
  blinkLED(4);
}

// the loop function runs over and over again forever
void loop() {
  getSwitchValue();
  getSensorValue();
  sendSerialData();
 
  // delay so as to not overload serial buffer
  delay(100);
}

//-- blink that number of times
void blinkLED(int numBlinks ) {
  for(int i=0; i<numBlinks; i++ ) 
  {
    digitalWrite(ledPin, HIGH); 
    delay(ledFlashDelay);  
    digitalWrite(ledPin, LOW); 
    delay(ledFlashDelay);  
  }
}

//-- look at the momentary switch (button) and show on/off
//-- display in the serial monitor a well
void getSwitchValue() {
  switchValue=digitalRead(buttonPin);
  
  if(switchValue==true) 
  {
     // Button is ON turn the LED ON by making the voltage HIGH
    digitalWrite(ledPin, HIGH);   
  } 
  else 
  {
    // Button is OFF turn the LED OFF by making the voltage LOW
    digitalWrite(ledPin, LOW);    // turn the LED off by making the voltage LOW      
  }
}

void getSensorValue() {
  sensorValue=analogRead(LDRPin);//Read in data from the LDR
}

//Send data to Processing
void sendSerialData() {
  // Add switch on or off
  //Serial.print("switchValue: ");
  Serial.print(switchValue);
  Serial.print(",");  
  //Serial.print(" sensorValue: ");
  Serial.print(sensorValue);
   
  // end with newline
  Serial.println();
}
