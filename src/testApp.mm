#include "testApp.h"

//--------------------------------------------------------------
ofImage testApp::executeWatershed(ofImage *input){
    ofxCvColorImage ofxSrc, ofxDst;
    IplImage        *srcImg, *markers, *dstImg;
    //IplImageの初期化
    srcImg = 0; markers = 0; dstImg = 0;
    
    //一旦ofxCvColorImageに画像を配置
    ofxSrc.setFromPixels(input->getPixels(), input->width, input->height);
    
    //IplImageの方に画像を受け渡す
    srcImg = ofxSrc.getCvImage();
    
    //マーカー画像用に初期化(depth: IPL_DEPTH_32S, nchannels: 1にしないといけない)
    markers = cvCreateImage(cvGetSize(srcImg), IPL_DEPTH_32S, 1);
    cvZero(markers);
    
    //結果画像の初期化
    dstImg = cvCloneImage(srcImg);
    
    //NUM_SEGMENT数マーカーをランダムに配置
    int seed_rad = 2;
    int seed_num = 0;
    for(int i=0;i<NUM_SEGMENT;i++){
        CvPoint pt;
        seed_num ++;
        pt = cvPoint(ofRandom(srcImg->width), ofRandom(srcImg->height));
        cvCircle(markers, pt, seed_rad, cvScalarAll(seed_num),CV_FILLED, 8, 0);
    }
    
    cvWatershed(srcImg, markers);
    
    //結果画像にwatershed境界（ピクセル値=-1）を結果表示要画像上に表示する
//    int *idx;
//    for(int i=0;i<markers->height;i++){
//        for(int j=0;j<markers->width;j++){
//            idx = (int *)cvPtr2D(markers, i, j, NULL);
//            if(*idx == -1)
//                cvSet2D(dstImg, i, j, cvScalarAll(255));
//            
//        }
//    }
    
    //表示用にofxDstに結果画像を受け渡す
    ofxDst.allocate(dstImg->width, dstImg->height);
    ofxDst = dstImg;
    //アルファ値を入力できるようにofImageに値を入れる
    ofImage returnImage;
    setAlphaImageFromCvImage(&ofxDst, &returnImage);
    
    //ここは書き方がおかしい（なぜかここで領域画像をregionImageに保存）
    regionImage = cvCloneImage(markers);
    
//    cvReleaseImage(&srcImg);
//    cvReleaseImage(&markers);
//    cvReleaseImage(&dstImg);
    
    
    return returnImage;
}

//--------------------------------------------------------------
void testApp::setAlphaImageFromCvImage(ofxCvColorImage *input, ofImage *output){
    unsigned char *tempPixels = new unsigned char [input->width*input->height*3];
    unsigned char *alphaPixels = new unsigned char [input->width*input->height*4];
    tempPixels = input->getPixels();
    
    for(int h=0;h<input->height;h++){
        for(int w=0;w<input->width;w++){
            for(int i=0;i<3;i++){
                alphaPixels[4*(w + input->width*h) + i] = tempPixels[3*(w + input->width*h) + i];
                
            }
            
            alphaPixels[4*(w + input->width*h) + 3] = 255;
        }
    }
    
    output->setFromPixels(alphaPixels, input->width, input->height, OF_IMAGE_COLOR_ALPHA);
    
}



//--------------------------------------------------------------
void testApp::setup(){
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(0,0,0);
    
    ofEnableAlphaBlending();
    
    
    img.loadImage("0.jpg");
    
    img.resize(ofGetWidth(), ofGetHeight());

    regionImage = 0;
    
    dst = executeWatershed(&img);

    //背景画像
    back.loadImage("1.jpg");
    back.resize(ofGetWidth(), ofGetHeight());
    

    
}


//--------------------------------------------------------------
void testApp::update(){
    int numRegion = 10;
    static int regionNo1 = 0;
    static int regionNo2 = numRegion;
    static int alpha = 255;
    
    int *idx;
    for(int h=0;h < regionImage->height;h++){
        for(int w=0;w < regionImage->width;w++){
            idx = (int *)cvPtr2D(regionImage, h, w,NULL);
            if(*idx >= regionNo1 && *idx < regionNo2){
                ofColor col = dst.getColor(w, h);
                col.a = alpha;
                dst.setColor(w, h, col);
                if(w-1 >= 0)
                    dst.setColor(w-1, h, col);
                if(w+1 < regionImage->width)
                    dst.setColor(w+1, h, col);
                if(h-1 >= 0)
                    dst.setColor(w, h-1, col);
                if(h+1 < regionImage->height)
                    dst.setColor(w, h+1, col);
            }
            
//            if(*idx == -1 && regionNo2 > NUM_SEGMENT){
//                ofColor col = dst.getColor(w, h);
//                col.a = alpha;
//                dst.setColor(w, h, col);
//                
//            }
            
        }
    }
    
    dst.update();
    
    alpha -=10;
    if(alpha < 0){
        alpha = 255;
        regionNo1 += numRegion;
        regionNo2 += numRegion;
    }
    
    static int oldNumPic = 1;
    
    if(regionNo1 >= (NUM_SEGMENT+20)){
        img = back;
        
        img.resize(ofGetWidth(), ofGetHeight());
        
        regionImage = 0;
        
        dst = executeWatershed(&img);
        
        
        int numPic;
        do{
            numPic = (int)ofRandom(NUM_PICTURE);
        }while(numPic == oldNumPic);
        
        oldNumPic = numPic;
        
        char fileName[10];
        sprintf(fileName, "%d.jpg",numPic);
        cout<<fileName<<endl;
        back.loadImage(fileName);
        back.resize(ofGetWidth(), ofGetHeight());
        
        regionNo1 = 0;
        regionNo2 = numRegion;
        
    }
    
}

//--------------------------------------------------------------
void testApp::draw(){
    back.draw(0, 0);
    
    dst.draw(0, 0);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
 
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

