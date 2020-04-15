/*
  ESP32ToProcessing
  by Alvin Tran
  Get data from ESP32 to manipulate a sketch in Processing
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      
String portName="/dev/tty.SLAB_USBtoUART";

// Data coming in from the data fields
String [] data;
int switchValue=0;    // index from data fields
int sensorValue=1;

// Boolean integer to see if switchValue equals 1
int onOff=0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex=0;

//Different colors to be used
color black=color(0, 0, 0);
color red=color(255, 0, 0);
color yellow=color(255, 255, 0);
color white=color(255, 255, 255);
color steelblue=color(70,130,180);

//Placement of text
int textPlacementX=400;
int textPlacementY=300;

//Original Vertices for triangle
int x1=395;
int y1=130;
int x2=230;
int y2=360;
int x3=570;
int y3=360;

//Timer
int startMillis;

//Global variable for font
PFont f;

void setup ( ) {
  size(800, 600);    
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort=new Serial(this, Serial.list()[serialIndex], 115200); 
  
  textAlign(CENTER);
  //f is created here
  f=createFont("Comic Sans MS", 36, true);
} 

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) 
  {
    String inBuffer=myPort.readString();  
    
    //print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer=(trim(inBuffer));
    
    data=split(inBuffer, ',');
 
    // do an error check here?
    switchValue=int(data[0]);
    sensorValue=int(data[1]);
  }
} 

void IsItOn(){
  if(switchValue==1)
  {
    drawBackground();
  }
  else
  {      
    if(millis()<=startMillis+2000)
    {
      background(black);      
      fill(white);     
    
      triangle(x1, y1, x2, y2, x3, y3);     
    
      textFont(f);       
      fill(black);
      text("I'm off!", textPlacementX, textPlacementY);
    }
    else if(millis()>=startMillis+2000 && millis()<=startMillis+4000)
    {    
      background(white);      
      fill(black);     
    
      triangle(x1, y1, x2, y2, x3, y3);     
    
      textFont(f);       
      fill(white);
      text("I'm off!", textPlacementX, textPlacementY);
    }     
    else
    {
      background(black);      
      fill(white);     
    
      triangle(x1, y1, x2, y2, x3, y3);     
    
      textFont(f);       
      fill(black);
      text("I'm off!", textPlacementX, textPlacementY);
      startMillis=millis();
    }
  }
}

void drawBackground() {
   if(sensorValue<=600)
   {
     background(yellow);     
     fill(red);       
     
     triangle(x1, y1, x2, y2, x3, y3);
     
    if(y1<=130 && y1>=25)
     {
       y1--;
       y2--;
       y3--;
       textPlacementY--;
     }
     else
     {
       x1=395;
       y1=130;
       x2=230;
       y2=360;
       x3=570;
       y3=360;
       textPlacementY=300;
     }
     
     textFont(f);       
     fill(black);
     text("I'm On Fire!", textPlacementX, textPlacementY);
   }

  else if(sensorValue>600)
  {
    if(millis()<=startMillis+2000)
    {
      background(steelblue);      
      textFont(f);       
      fill(white);
      text("I'm Away from the Fire!", textPlacementX, textPlacementY); 
    }
    else if(millis()>=startMillis+2000 && millis()<=startMillis+4000)
    {    
      background(white);      
      textFont(f);       
      fill(steelblue);
      text("I'm Away from the Fire!", textPlacementX, textPlacementY);
    }
    else
    {
      background(steelblue);      
      textFont(f);       
      fill(white);
      text("I'm Away from the Fire!", textPlacementX, textPlacementY); 
      startMillis=millis();
    }
  }
}

void draw ( ) {  
  
  if(mousePressed)//Able to check coordinates with mouse
  {
    int x=mouseX;
    int y=mouseY;
    println("X: "+x+" Y: "+y);
  }

  // every loop, look for serial information
  checkSerial();
  IsItOn();
} 
