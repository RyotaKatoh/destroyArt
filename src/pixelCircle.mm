//
//  pixelCircle.cpp
//  Gogh
//
//  Created by 加藤 亮太 on 2013/03/04.
//
//

#include "pixelCircle.h"

pixelCircle::pixelCircle(int _radius){
    radius = _radius;
}

pixelCircle::~pixelCircle(){
    pixcelColor.clear();
    pixcelPoint.clear();
}

void pixelCircle::setCircle(int centerX, int centerY, ofImage img){
    
    for(int y=-radius;y<=radius;y++){
        int x = radius*cos(y/(float)radius);
        cout<<x<<endl;
    }


}