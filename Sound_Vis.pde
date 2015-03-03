//Minim code used from Minim samples:
//http://code.compartmental.net/tools/minim/quickstart/
//Minim visualization

/* --- PRE SETUP --- */
import ddf.minim.*;

//sound vars
String files[] = {"blue","determined","ecstatic","hopeful","insane","melancholy","red",
                  "defeated","fastidious","tenacious","voracious","zealous","epic",
                  "ethereal","invincible","magnanimous","nefarious"};
int fileCount = files.length;

//button vars
int[] buttonX = new int[fileCount];
int[] buttonY = new int[fileCount];
int[] buttonSize = new int[fileCount];
int buttonW = 150;
int buttonH = 50;
int range = 10;

//Minim vars
Minim minim;
AudioPlayer player[] = new AudioPlayer[fileCount];
int playing = -1;

//waveform vars
int sw = 1024;
int sh = 600;
int cs = 32;

//timer vars
int timer = 0;
int delay = 10000;

/* ----- SETUP ----- */
void setup() {
  //create a new window
  size(sw, sh);
  
  //new Minim instance
  minim = new Minim(this);
  
  //initialize players
  for(int i = 0; i < fileCount; i++) {    
    player[i] = minim.loadFile(files[i]+"_a.wav");
  }
  
  //initialize buttons
  for(int b = 0; b < fileCount; b++) {
    buttonX[b] = int(random(100,sw-100));
    buttonY[b] = int(random(100,sh-100));
    buttonSize[b] = int(random(18))+12;
  }
}

/* --- MAIN LOOP --- */
void draw() {
  
  //draw faded background
  fill(0,0,50,128);
  rect(0,0,width,height);
 
  //draw waveforms
  if(millis() - timer <= delay) {
    if(playing > -1) {
      drawWaveform(player[playing]);
    }
  }
  
  //draw buttons
  for(int b = 0; b < fileCount; b++) {
    drawButton(b);
  }
   
  //draw cursor.
  drawCursor();
    
}

//draw button helper function
void drawButton(int i) {
  //move the button
  int bX = buttonX[i] + int(sin(millis()*.002+buttonX[i])*range); 
  int bY = buttonY[i] + int(sin(millis()*.004+buttonY[i])*range);
  int bS = buttonSize[i] + int(sin(millis()*.006+buttonSize[i])*range/2);
  //set default text parameters
  if(playing != i) { fill(255); } 
  else { fill(80,160,120); }
  textSize(bS);
  //if mouse over button 
  if(mouseX > bX && mouseX < bX+buttonW &&
     mouseY > bY-30 && mouseY-30 < bY+buttonH) {
    //set mouse hover text parameters.
    if(playing != i) { fill(180); } 
    else { fill(100,140,180); }
    textSize(bS*3/2);
    //and click
    if(mousePressed) {
      timer = millis();
      if(playing > -1) {
        player[playing].pause();
        player[playing].rewind();
      }
      player[i].play();
      playing = i;
    }
  }
  //draw text
  text(files[i],bX,bY);   
}

//draw cursor helper function
void drawCursor() {
  stroke(255);
  strokeWeight(1.5);
  //draw circle
  beginShape();
  //first vertex
  int fx = mouseX+int(random(cs))-cs/2;
  int fy = mouseY+int(random(cs))-cs/2;
  //draw an arbitrary amount of vertices
  for(int i = 0; i < int(random(6))+1; i++) {
    vertex(mouseX+int(random(cs))-cs/2,mouseY+int(random(cs))-cs/2);
    vertex(mouseX+int(random(cs))-cs/2,mouseY+int(random(cs))-cs/2);
  }
  //end vertex
  vertex(fx,fy);
  endShape(CLOSE);
}
//draw waveforms helper function
void drawWaveform(AudioPlayer song) {
  //draw slight teal glow.
  stroke(0,120,180,32);
  strokeWeight(8);
  for(int i = 0; i < song.bufferSize() - 1; i++) {
    line(i, sh*.33 + song.left.get(i)*sh*.2, i+1, sh*.33 + song.left.get(i+1)*sh*.2);
    line(i, sh*.66 + song.right.get(i)*sh*.2, i+1, sh*.66 + song.right.get(i+1)*sh*.2);
  }
  //draw white lightning streak.
  stroke(255);
  strokeWeight(1.5);
  for(int i = 0; i < song.bufferSize() - 1; i++) {
    line(i*sw/1024, sh*.33 + song.left.get(i)*sh*.2, (i+1)*sw/1024, sh*.33 + song.left.get(i+1)*sh*.2);
    line(i*sw/1024, sh*.66 + song.right.get(i)*sh*.2, (i+1)*sw/1024, sh*.66 + song.right.get(i+1)*sh*.2);
  }
}

