package com.example.androidthings.myproject;

import android.util.Log;

import com.google.android.things.contrib.driver.mma8451q.Mma8451Q;

import java.io.IOException;


/**
 * HW3 Template
 * Created by bjoern on 9/12/17.
 * Wiring:
 * USB-Serial Cable:
 *   GND to GND on IDD Hat
 *   Orange (Tx) to UART6 RXD on IDD Hat
 *   Yellow (Rx) to UART6 TXD on IDD Hat
 * Accelerometer:
 *   Vin to 3V3 on IDD Hat
 *   GND to GND on IDD Hat
 *   SCL to SCL on IDD Hat
 *   SDA to SDA on IDD Hat
 * Analog sensors:
 *   Middle of voltage divider to Analog A0..A3 on IDD Hat
 */

public class Newhw3 extends SimplePicoPro {

    Mma8451Q accelerometer;

    float[] xyz = {0.f,0.f,0.f}; //store X,Y,Z acceleration of MMA8451 accelerometer here [units: G]
    float a0,a1,a2,a3; //store analog readings from ADS1015 ADC here [units: V]

    float f0,f1,f0_min,f0_max,f1_min,f1_max;
    boolean flag;
    float flex,flex_min,flex_max;
    float x,y;//calculated
    float flex0;//calculated
    public void setup() {

        // Initialize the serial port for communicating to a PC
        uartInit(UART6,9600);

        //
        flag = false;
        f0_min = .0f;
        f0_max = 3.4f;
        f1_min = .0f;
        f1_max = 3.4f;
        flex_min = 1.0f;
        flex_max = 2.2f;
        // Initialize the Analog-to-Digital converter on the HAT
        analogInit(); //need to call this first before calling analogRead()

        // Initialize the MMQ8451 Accelerometer
        try {
            accelerometer = new Mma8451Q("I2C1");
            accelerometer.setMode(Mma8451Q.MODE_ACTIVE);
        } catch (IOException e) {
            Log.e("HW3Template","setup",e);
        }
    }


    public float getY(){
        return (f0-f0_min)/(f0_max-f0_min);
    }

    public float getX(){
        return (f1-f1_min)/(f1_max-f1_min);
    }

    public float getFlex0(){
        return (flex-flex_min)/(flex_max-flex_min);
    }


    public void loop() {
        // read all analog channels and print to UART
//        a0 = analogRead(A0);
//        a1 = analogRead(A1);
//        a2 = analogRead(A2);
//        a3 = analogRead(A3);
//        println(UART6,"A0: "+a0+"   A1: "+a1+"   A2: "+a2+"   A3: "+a3); // this goes to the Serial port
//        println("A0: "+a0+"   A1: "+a1+"   A2: "+a2+"   A3: "+a3); // this goes to the Android Monitor in Android Studio

        //joystick part
        f0=analogRead(A0);
        f1=analogRead(A1);

        //flex sensor part
        flex=analogRead(A2);


        x = getX();
        y = getY();

        flex0=getFlex0();

        if(x<.4f && y <.4f ){
            //printCharacterToScreen('e');
            //println("topleft");
            //topLeftHit();
            flag = true;
        }
        if(x>.4 && x<.6 && y<.4){
            //printCharacterToScreen('e');
           // println("top");
            //topLeftHit();
            flag = true;
        }
        if(x>.6f && y <.4f ){
            //println("topright");
            //topRightHit();
            flag = true;
        }
        if(x<.4f && y >.4f&&y<.6f ){
            //println("left");
            //bottomLeftHit();
            flag = true;
        }
        if(x>.6f && y >.4f&&y<.6f ){
            //println("right");
            //bottomLeftHit();
            flag = true;
        }
        if(x<.4f && y >.6f ){
            //println("bottomleft");
            //bottomLeftHit();
            flag = true;
        }
        if(x>.6f && y >.6f ){
            //println("bottomright");
            //bottomRightHit();
            flag = true;
        }
        if(x>.4 && x<.6 && y>.6 ){
            //println("bottomhit");
            //bottomHit();
            flag = true;
        }
        if(x>.4 && x<.6 && y>.4 && y<.6){
           // println("zero");

            flag = false;
        }
        //println("A0: "+f0+"   A1: "+f1);
        //println(UART6,f0+" "+f1);

        // read I2C accelerometer and print to UART
        try {
          xyz = accelerometer.readSample();
           // println(UART6,"X: "+xyz[0]+"   Y: "+xyz[1]+"   Z: "+xyz[2]);
           // println(UART6,xyz[0]+" "+xyz[1]+" "+xyz[2]);
            //println("X: "+xyz[0]+"   Y: "+xyz[1]+"   Z: "+xyz[2]);

            //use this line instead for unlabeled numbers separated by tabs that work with Arduino's SerialPlotter:
            //println(UART6,xyz[0]+"\t"+xyz[1]+"\t"+xyz[2]); // this goes to the Serial port

        } catch (IOException e) {
            Log.e("HW3Template","loop",e);
        }
        //println("A0: "+x+"   A1: "+y+" X: "+xyz[0]+"   Y: "+xyz[1]+"   Z: "+xyz[2]+" Flex: "+flex0);
        println(UART6,f0+" "+f1+" "+xyz[0]+" "+xyz[1]+" "+xyz[2]+" "+flex0);
        delay(100);
    }
}
