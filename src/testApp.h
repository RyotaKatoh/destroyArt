#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "pixelCircle.h"

#include "ofxOpenCv.h"

#define NUM_SEGMENT 200  //分割数
#define NUM_PICTURE 20    //画像数

class testApp : public ofxiPhoneApp{
	
public:
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    void setAlphaImageFromCvImage(ofxCvColorImage *input, ofImage *output);
    
    ofImage executeWatershed(ofImage *input);
    
    ofImage img;
    ofImage back;
    ofImage dst;
    IplImage *regionImage;

};


