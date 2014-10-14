#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
	ofSetFrameRate(60);
    ofSoundStreamSetup(2, 0, this, kAudioSampleRate, kAudioBufferSize, 4);
    
    tone_ = new ofxRP2A03();
    mesh.setMode(OF_PRIMITIVE_TRIANGLE_STRIP);
    drawMode = true;
    rotateMode = false;
    
//    ofVec2f vec = ofVec2f(ofGetWidth()/2-3,0);
//    points.push_back(vec);
    
    boxBtnX = ofGetWidth()-100;
    boxBtnY = ofGetHeight()-100;
    eraseBtnX = ofGetWidth()-100;
    eraseBtnY = ofGetHeight()-180;
    rotateBtnX = ofGetWidth()-100;
    rotateBtnY = ofGetHeight()-260;
    btnWidth = 60;
    maxBoxes = 40;
    enemyX = 10;
    enemyY = 10;
    heroX = ofGetWidth()/2;
    heroY = ofGetHeight()/2;

}

// Preset Program Table:
//   {"WaveForm", "PitchEnvType", "PitchEnvRate",
//    "PitchEnvDepth", "VolumeEnvType, "VolumeEnvRate"}
const int ofApp::kPresetTable[kPolyphonyVoices][6] = {
    {0, 2, 25, 100, 1, 25},
    {3, 0, 50, 100, 0, 50},
    {1, 0, 25, 100, 2, 25},
    {2, 0, 50,   0, 0, 50}
};

//--------------------------------------------------------------
void ofApp::update(){
    mesh.clear();
    for (int i=0; i<points.size(); i++) {
        int y = points[i].y;
        if (y>0-5) {
            points[i].y = y-4;
        } else {
            points[i].y = ofGetHeight()+5;
            
            
            int note_number = 36 + points[i].x / ofGetWidth() * kKeyRange;
            
            int rect_height = ofGetHeight() / kPolyphonyVoices;
            int program_index = points[i].y / rect_height;
            if (program_index == 4) program_index = 3;
            tone_->setProgram(kPresetTable[program_index]);
            
            int tone_y = static_cast<int>(points[i].y) % rect_height;
            int volume_env_rate = static_cast<float>(tone_y) / rect_height * 127;
            tone_->setVolumeEnvRate(volume_env_rate);
            
            tone_->play(note_number,
                                   1.0,                  // volume
                                   ofRandom(0.0, 1.0));  // pan
            
        }
        ofVec3f vec3f = ofVec3f(points[i].x, points[i].y);
        mesh.addVertex(vec3f);
        if (enemyX - heroX) {
            enemyX = enemyX+0.1;
        }
        if (enemyY - heroY) {
            enemyY = enemyY+0.1;
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofBackground(0,0,0);
        for (int i=0; i<points.size(); i++) {
            ofPushMatrix();
            ofSetColor(255, 255, 255);
            ofFill();
            ofRotateY(pointsRotation[i]);
            //ofDrawSphere(points[i].x, points[i].y, 10);
            //ofDrawBox(points[i].x, points[i].y, 0,10);
            ofDrawBox(points[i].x, points[i].y, 0,6,6,300);
            //ofVertex(points[i].x, points[i].y);
            ofPopMatrix();
        }
    //mesh.draw();
    drawButtons();
    ofSetColor(255, 255,255);
    ofEllipse(heroX, heroY, 20, 20);
    ofPushMatrix();
    float a = atan2(enemyY-heroY, enemyX-heroX);
    ofRotate(-a);
    ofSetLineWidth(2);
    ofLine(enemyX, enemyY, enemyX+10, enemyY);
    ofPopMatrix();
    
}

//--------------------------------------------------------------
void ofApp::exit(){
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    if (abs(touch.x-boxBtnX)<btnWidth/2 && abs(touch.y-boxBtnY)<btnWidth/2) {
        drawMode = true;
    } else if (abs(touch.x-eraseBtnX)<btnWidth/2 && abs(touch.y-eraseBtnY)<btnWidth/2) {
        drawMode = false;
    } else if (abs(touch.x-rotateBtnX)<btnWidth/2 && abs(touch.y-rotateBtnY)<btnWidth/2) {
        rotateMode = !rotateMode;
    } else {
        touchAction(touch.x,touch.y);
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchAction(touch.x,touch.y);
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

void ofApp::touchAction(int x, int y) {
    ofVec2f vec = ofVec2f(x,y);
    if (!drawMode) {
        for (int i=0; i<points.size(); i++) {
            float dist = vec.distance(points[i]);
            
            if (dist < 30) {
                points.erase(points.begin()+i);
                pointsRotation.erase(pointsRotation.begin()+i);
            }
        }
    } else if(rotateMode) {
        for (int i=0; i<points.size(); i++) {
            float dist = vec.distance(points[i]);
            
            if (dist < 30) {
                pointsRotation[i] = 90;
            }
        }
    } else
    {
        if (points.size() > maxBoxes) {
            points.erase(points.begin());
            pointsRotation.erase(pointsRotation.begin());
        }
        
        if (points.size() > 0 && points[points.size()-1].distance(vec)<10) {
            return;
        } else {
            points.push_back(vec);
            pointsRotation.push_back(0);
        }
    }
   
}

void ofApp::drawButtons() {
    ofNoFill();
    ofSetColor(255, 255,255);
    ofDrawPlane(boxBtnX, boxBtnY, btnWidth, btnWidth);
    ofDrawPlane(eraseBtnX, eraseBtnY, btnWidth, btnWidth);
    ofDrawPlane(rotateBtnX, rotateBtnY, btnWidth, btnWidth);
    ofSetColor(0,0,0);
    ofNoFill();
    ofDrawBox(boxBtnX, boxBtnY, 0, btnWidth/2);
}

void ofApp::audioOut(float *output, int buffer_size, int n_channels) {
    // clear buffer
    for (int i = 0; i < buffer_size; ++i) {
        output[i * n_channels] = 0;
        output[i * n_channels + 1] = 0;
    }
    
    tone_->audioOut(output, buffer_size, n_channels);
}
