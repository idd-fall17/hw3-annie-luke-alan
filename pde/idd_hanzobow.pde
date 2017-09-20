
// Sensor graphing sketch
// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects float values in the
// range of -1.0 to 1.0, followed by a newline, or newline and carriage return

// Created 20 Apr 2005
// Updated 18 Jan 2008 by Tom Igoe
// Adapted 16 Sep 2014 by Bjoern Hartmann for mbed
// This example code is in the public domain.

import processing.serial.*;
import java.util.Scanner;
import java.awt.*;
//import java.awt.Robot;
//import java.awt.MouseInfo;
import java.awt.event.KeyEvent;
import java.awt.event.InputEvent;



Robot rbt;
float[] xy = new float[2];//for keyboard
Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
Point p;

float[] xyz = new float[3];
float f0_min = .0f;
float f0_max = 3.4f;
float f1_min = .0f;
float f1_max = 3.4f;
float[] inixyz = {0f, -0.125f, 1f};
float[] thresxyz = {0.10f, 0.03f};
final int[] sensitivity = {80, 50};

float flex;
//float flex_min = 1.1f;
//float flex_max = 2.25f;


void setup () {
  // set the window size:
  size(300, 400);        
  //this.frame.setVisible(false);
  //
  try {
    rbt = new Robot();
  } catch(Exception e) {
    e.printStackTrace();
  }

  // List all the available serial ports to help you find the one you need
  println(Serial.list());
  // Open whatever port is the one you're using.
  myPort = new Serial(this, "COM3", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(236,240,241);
}



void draw () {
  // everything happens in the serialEvent()
  
  // Mouse Click
  //float flexxing=(flex-flex_min)/(flex_max-flex_min);
  if(flex <.7f &&flex > 0f) rbt.mousePress(InputEvent.BUTTON1_MASK);
  else if (flex > 0.5f)     rbt.mouseRelease(InputEvent.BUTTON1_MASK);////////////////////////////////////////////////////////

  
  //KeyBoard Event
  if (xy[1]>.6f){ //(xy[0] > .4f &&xy[0]<.6f &&ddddddddddddddddddd
    rbt.keyPress(KeyEvent.VK_D);
    delay(1);
    rbt.keyRelease(KeyEvent.VK_D);
    //i=1;
  }
  if( xy[1]<.4f){ //xy[0] > .4f &&xy[0]<.6f &&
    rbt.keyPress(KeyEvent.VK_A);
    delay(1);
    rbt.keyRelease(KeyEvent.VK_A);
    //i=2;
  }
  if( xy[0]>.6f){ //xy[1] > .4f &&xy[1]<.6f &&
    rbt.keyPress(KeyEvent.VK_S);
     delay(1);
    rbt.keyRelease(KeyEvent.VK_S);
    //i=3;
  }
  if(xy[0]<.4f){ //xy[1] > .4f &&xy[1]<.6f && 
    rbt.keyPress(KeyEvent.VK_W);
     delay(1);
    rbt.keyRelease(KeyEvent.VK_W);
    //i=4;
  }
  
  //Mouse Event
  p = MouseInfo.getPointerInfo().getLocation();
 
  int xdist = 0, ydist = 0;
  
 

  if (xyz[0] > inixyz[0] + thresxyz[0]) {
    xdist = int (sensitivity[0] * pow((xyz[0] - thresxyz[0])/(1 - thresxyz[0]), 2));
    //rbt.mouseMove(p.x - dist, p.y);
  } else if (xyz[0] < inixyz[0] - thresxyz[0]) {
    xdist = -1 * int (sensitivity[0] * pow((thresxyz[0] - xyz[0])/(thresxyz[0] + 1), 2));
    //println("dist: " + dist);
    //rbt.mouseMove(p.x + dist, p.y);
  }
    
  if (xyz[1] > inixyz[1] + thresxyz[1]) {
    ydist = -1 * int ((sensitivity[1] + 20) * pow((xyz[1] - thresxyz[1])/(1 - thresxyz[1]), 2)); 
    //rbt.mouseMove(p.x, p.y - dist);
  } else if (xyz[1] < inixyz[1] - thresxyz[1]) {
    ydist = int (sensitivity[1] * pow((thresxyz[1] - xyz[1])/(thresxyz[1] + 1), 2));
    //rbt.mouseMove(p.x, p.y + dist);
  }
  
  //if (xyz[1] > thresxyz[1])
  rbt.mouseMove(p.x + xdist, p.y + ydist);
  //else
  //  rbt.mouseMove(p.x - xdist, p.y + ydist);
  //println(p.x + " " + p.y);


}





////////////////////////
void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    Scanner scanner = new Scanner(inString);
    
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    float inFloat =0.f;
    try{
     xy[0] = (scanner.nextFloat()-f0_min)/(f0_max-f0_min);
     xy[1] = (scanner.nextFloat()-f1_min)/(f1_max-f1_min);
     xyz[0] = scanner.nextFloat();
     xyz[1] = scanner.nextFloat();
     xyz[2] = scanner.nextFloat();
     flex = scanner.nextFloat();
     
    } catch (Exception e) {
      print(e);
    }
    //printArray(xy);
    println("xx "+xy[0]+" yy "+xy[1]+" x: " + xyz[0] + " y: " + xyz[1] + " z: " + xyz[2]+" flex "+flex);
    //printArray(xyz);
    //if(count%2==0){
    //  print("x:"+(inFloat-f0_min)/(f0_max-f0_min)+"\n");
    //  xy[0]=(inFloat-f0_min)/(f0_max-f0_min);
    //  count++;
    //}else{
    //  print("y:"+(inFloat-f0_min)/(f0_max-f0_min)+"\n");
    //  xy[1]=(inFloat-f0_min)/(f0_max-f0_min);
    //  count++;
    //}
    
    
    //float screenY = map(inFloat, -1.0, 1.0, 0, height);

    // draw the line from bottom of screen to desired height
    //stroke(61,126,155);
    //line(xPos, height, xPos, height - screenY);

    // at the edge of the screen, go back to the beginning:
    //if (xPos >= width) {
      //xPos = 0;
      //background(236,240,241);
    //} else {
      // increment the horizontal position:
      //xPos++;
    //}
  }
}

void keyPressed() {
  if (key ==CODED && keyCode == ESC)
    exit();
}