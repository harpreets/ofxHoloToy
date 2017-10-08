#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofHolotoy.h"

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
    
        void generatePositions();
        void drawWalls();
        void drawObjects();

        UserPerspectiveCam perspectiveCam;
    
    private:
        ofVec3f userPosition;
        ofDirectory directory;
        vector<ofImage*> floatingImages, activeImages;
        vector<ofVec3f> floatingLinePositions;
        float timekeeper;
        int imgCounter;
};


