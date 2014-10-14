#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxRP2A03.h"



class ofApp : public ofxiOSApp {
	
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
        void touchAction(int x, int y);
        void drawButtons();
    
        vector <ofVec2f>points;
        vector <int>pointsRotation;
        ofMesh mesh;
        int heroX;
        int heroY;
        float enemyX;
        float enemyY;
        int boxBtnX;
        int boxBtnY;
        int eraseBtnX;
        int eraseBtnY;
        int rotateBtnX;
        int rotateBtnY;
        int maxBoxes;
        int btnWidth;
        int blockHeight;
        bool drawMode;
        bool rotateMode;
    
        void audioOut(float* output, int buffer_size, int n_channels);
    
private:
    
    static const int kPolyphonyVoices = 4;
    static const int kPresetTable[kPolyphonyVoices][6];
    static const int kKeyRange = 48;
    static const int kAudioSampleRate = 44100;
    static const int kAudioBufferSize = 1024;
    
    ofxRP2A03* tone_;
};


