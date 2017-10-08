#include "testApp.h"

float round (float);
//--------------------------------------------------------------
void testApp::setup(){
    ofEnableSmoothing();
    glEnable(GL_CULL_FACE);
    
	// initialize the accelerometer
	ofxAccelerometer.setup();
		
	ofBackground(0);
    
    perspectiveCam.setNearClip(0.1f);
    perspectiveCam.setFarClip(6000.0f);
    perspectiveCam.setViewPortalWindow(ofVec3f(0                    , 0, 0),
                                       ofVec3f(IPAD2_PORTRAIT_WIDTH , 0, 0),
                                       ofVec3f(0                    , IPAD2_PORTRAIT_HEIGHT, 0),
                                       ofVec3f(IPAD2_PORTRAIT_WIDTH , IPAD2_PORTRAIT_HEIGHT, 0));
    
    userPosition.set(IPAD2_PORTRAIT_WIDTH/2, IPAD2_PORTRAIT_HEIGHT/2, 15);
    
    //Directory images
    this->generatePositions();
    directory.open(companyPath);
    directory.allowExt("jpg");
    directory.listDir();
    
    for(int i=0;i<directory.numFiles();++i){
        ofImage* icoImage = new ofImage(directory.getPath(i));
        floatingImages.push_back(icoImage);
    }
    timekeeper = ofGetElapsedTimef();
}

//--------------------------------------------------------------
void testApp::update(){
    userPosition.set(round(ofMap(ofxAccelerometer.getForce().x, -1,  1, IPAD2_PORTRAIT_WIDTH, 0)),
                     round(ofMap(ofxAccelerometer.getForce().y, -1,  1, 0, IPAD2_PORTRAIT_HEIGHT)), 15);
    perspectiveCam.setUserPosition(userPosition);
    
    //Image changing on interval expire
    if((ofGetElapsedTimef() - timekeeper) > CHANGE_INTERVAL){
        timekeeper = ofGetElapsedTimef();
        activeImages.clear();
        for(int i=0;i<NUM_FLOATING_IMAGES;++i){
            activeImages.push_back( floatingImages.at( (imgCounter % directory.size() ) ));
            imgCounter+=1;
        }
        imgCounter = (imgCounter % directory.size());
    }
}

//--------------------------------------------------------------
void testApp::draw(){
	perspectiveCam.begin();
        drawWalls();
        drawObjects();
    perspectiveCam.end();
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
    this->generatePositions();
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

//--------------------------------------------------------------
void testApp::drawWalls(){
    float sideLinesDist = IPAD2_PORTRAIT_HEIGHT / SIDE_WALLS_NUM,
          upLinesDist = IPAD2_PORTRAIT_WIDTH / UPDOWN_WALLS_NUM,
          sideDepthLinesDist = LINES_DEPTH / SIDE_WALLS_CROSS_NUM,
          upDepthLinesDist = LINES_DEPTH / UPDOWN_WALLS_CROSS_NUM;
    ofPushStyle();
        ofSetLineWidth(4);
        ofSetColor(255);
        for(int i=0;i<=SIDE_WALLS_NUM;++i){
            ofLine(0, i* sideLinesDist, 0, 0, i* sideLinesDist, LINES_DEPTH);
            ofLine(IPAD2_PORTRAIT_WIDTH, i* sideLinesDist, 0, IPAD2_PORTRAIT_WIDTH, i* sideLinesDist, LINES_DEPTH);
        }
        for(int i=0;i<=UPDOWN_WALLS_NUM;++i){
            ofLine(i * upLinesDist, 0, 0, i * upLinesDist, 0, LINES_DEPTH);
            ofLine(i * upLinesDist, IPAD2_PORTRAIT_HEIGHT, 0, i * upLinesDist, IPAD2_PORTRAIT_HEIGHT, LINES_DEPTH);
        }
        for(int i=1;i<=SIDE_WALLS_CROSS_NUM + 7;++i){
            ofLine(0, 0, i*sideDepthLinesDist, 0, IPAD2_PORTRAIT_HEIGHT, i*sideDepthLinesDist);
            ofLine(IPAD2_PORTRAIT_WIDTH, 0, i*sideDepthLinesDist, IPAD2_PORTRAIT_WIDTH, IPAD2_PORTRAIT_HEIGHT, i*sideDepthLinesDist);
        }
        for(int i=1;i<=UPDOWN_WALLS_NUM + 5;++i){
            ofLine(0, 0, i*upDepthLinesDist, IPAD2_PORTRAIT_WIDTH, 0, i*upDepthLinesDist);
            ofLine(0, IPAD2_PORTRAIT_HEIGHT, i*upDepthLinesDist, IPAD2_PORTRAIT_WIDTH, IPAD2_PORTRAIT_HEIGHT, i*upDepthLinesDist);
        }
    ofPopStyle();
}

//--------------------------------------------------------------
void testApp::drawObjects(){
    glEnable(GL_DEPTH_TEST);
    ofPushStyle();
    ofSetLineWidth(4);
    ofSetColor(255);
        for(int i=0;i<activeImages.size();++i){
            ofVec3f pos = floatingLinePositions.at(i);
            activeImages.at(i)->bind();
            ofPushMatrix();
                ofScale(1, 1, 0.1);
                    ofLine(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z - 100);
                    ofBox(pos.x, pos.y, pos.z, 20);
            ofPopMatrix();
            activeImages.at(i)->unbind();
        }
    ofPopStyle();
    glDisable(GL_DEPTH_TEST);
}

void testApp::generatePositions(){
    floatingLinePositions.clear();
    for(int i=0;i<NUM_FLOATING_IMAGES;++i){
        float x = ofMap(ofRandomuf(), 0, 1, 0 +50, IPAD2_PORTRAIT_WIDTH -50),
              y = ofMap(ofRandomuf(), 0, 1, 0 + 50, IPAD2_PORTRAIT_HEIGHT -50),
              z = ofMap(ofRandomuf(), 0, 1, -5.0, LINES_DEPTH);
        floatingLinePositions.push_back(ofVec3f(x, y, z));
    }
}

float round (float f){
    return  floor(f + 0.5);
}
