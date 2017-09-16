package com.example.androidthings.myproject;


import android.util.Log;

import java.io.IOException;

import com.google.android.things.contrib.driver.mma8451q.Mma8451Q;
/**
 * Created by kh934 on 9/15/2017.
 */

public class flexsensor extends SimplePicoPro {

    Mma8451Q accelerometer;

    float[] xyz = {0.f, 0.f, 0.f}; //store X,Y,Z acceleration of MMA8451 accelerometer here [units: G]
    float a0, a1, a2, a3; //store analog readings from ADS1015 ADC here [units: V]

    float f0, f1, f0_min, f0_max, f1_min, f1_max;
    float VCC = 4.98f;


    public void setup() {

        // Initialize the serial port for communicating to a PC
        uartInit(UART6, 9600);

        //

        f0_min = 1.1f;
        f0_max = 2.25f;

        // Initialize the Analog-to-Digital converter on the HAT
        analogInit(); //need to call this first before calling analogRead()

        // Initialize the MMQ8451 Accelerometer

    }

    public void loop() {
        f0=analogRead(A2);
        float percent=(f0-f0_min)/(f0_max-f0_min);
        println("A0: "+percent);
        delay(100);
    }
}
