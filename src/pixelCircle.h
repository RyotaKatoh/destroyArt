//
//  pixelCircle.h
//  Gogh
//
//  Created by 加藤 亮太 on 2013/03/04.
//
//

#ifndef __Gogh__pixelCircle__
#define __Gogh__pixelCircle__

#include <iostream>
#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

class pixelCircle{
    
public:
    
    pixelCircle(int _radius);
    ~pixelCircle();
    
    int radius;
    
    vector<ofColor> pixcelColor;
    vector<ofPoint> pixcelPoint;
    
    void setCircle(int centerX, int CenterY, ofImage img);
};

#endif /* defined(__Gogh__pixelCircle__) */
