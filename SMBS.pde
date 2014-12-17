//
//Andrew Booth
//DMS 110
//Final Project
//Saturday Morning Breakfast Survival
//

//fisica imports
import fisica.util.nonconvex.*;
import fisica.*;

//Minim imports/stuff
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer jumpNoise;
AudioPlayer liftNoise;
AudioPlayer placeNoise;

int tileSize = 32;
int KonamiCounter;

void setup(){
  size(20*tileSize, 20*tileSize);
  imageImporter();  //Import images
  noCursor();
  
  Fisica.init(this);    //Get fisica running
  
  minim = new Minim(this);
  jumpNoise = minim.loadFile("jumpNoise.wav");
  liftNoise = minim.loadFile("manGruntingNoise.wav");
  placeNoise = minim.loadFile("boxPlacingNoise.wav");
  
  currentLevelNum = 1;
  maxLevel = 1;
  finalLevel = 4;
  pauseMode = 0;
  KonamiCounter = 0;
}//End setup()



int pauseMode;
int maxLevel;
int finalLevel;

//Items for level
Level cLevel;
Player cPlayer1, cPlayer2;
Milk cMilk;
ArrayList<Block> cBlockList;

boolean blinker;

void draw(){
  switch(pauseMode){
    case 0:
      //Beginning pause
      startMenu(maxLevel);
      break;
    case 1:
      //Level finish pause
      if((currentLevelNum == maxLevel)&&(maxLevel != finalLevel)){
        maxLevel++;
      }
      background(#99D1F5);
      fill(#2AE884);
      cMilk.update();
      cLevel.step();
      cLevel.draw();
      levelFinishMenu();
      break;
    case 2:
      //Mid-game pause
      midGamePauseMenu();
      break;
    case 3:
      //Gameover
      gameoverMenu();
      break;
    default:
      //Game is running, update stuff
      background(#99D1F5);
      fill(#2AE884);
      rect(-1, -1, width + 2, tileSize*3);
      if(frameCount%25 == 0){ blinker = !blinker; }
      //Update
      for(Block currBlock : cBlockList){
        currBlock.update();
      }
      cMilk.update();
      
      cLevel.step();
      cLevel.draw();
      
      if(cLevel.twoIn){
        //Two players
        if(cLevel.endSensor.isTouchingBody(cPlayer1)&&cLevel.endSensor.isTouchingBody(cPlayer2)){
          cMilk.setPaused(true);
          pauseMode = 1;
        }else if(cPlayer1.isDead||cPlayer2.isDead){
          pauseMode = 3;
        }
      }else{
        //One player
        if(cLevel.endSensor.isTouchingBody(cPlayer1)){
          cMilk.setPaused(true);
          pauseMode = 1;
        }else if(cPlayer1.isDead){
          pauseMode = 3;
        }
      }
      
      cPlayer1.update(cMilk);
      cPlayer2.update(cMilk);
      
      if(currentLevelNum == 1){
        fill(#F51119);
        textAlign(RIGHT);   
        textSize(12);
        if(millis() - cMilk.startTime < 5*1000){
          text("Use 'W', 'A', & 'D' to move.", width - tileSize, height/2);
        }
        if((millis() - cMilk.startTime < 10*1000)&&(millis() - cMilk.startTime > 5*1000)){
          text("Use 'S' while on top of Tini Wheats to pick them up.", width - tileSize, height/2 + 15);
        }
        if((millis() - cMilk.startTime < 15*1000)&&(millis() - cMilk.startTime > 10*1000)){
          text("Press 'S' and left or right to pick up a block next to you.", width-tileSize, height/2 + 30);
        }
        if((millis() - cMilk.startTime < 30*1000)&&(millis() - cMilk.startTime > 15*1000)){
          fill(#F51119);
          textAlign(LEFT);
          text("Stack the Tini Wheats to get out of the bowl and escape the rising milk!", 3.5*tileSize - 10, 4.5*tileSize);
          fill(#F5AD11);
          triangle(2.5*tileSize, 3.5*tileSize + 0.5*tileSize*sin(frameCount/frameRate), 2*tileSize, 4*tileSize + 0.5*tileSize*sin(frameCount/frameRate), 3*tileSize, 4*tileSize + 0.5*tileSize*sin(frameCount/frameRate));          
          rect(2.2*tileSize, 4*tileSize - 1 + 0.5*tileSize*sin(frameCount/frameRate), 0.6*tileSize, tileSize);
        }
      }
      
      if((millis() - cMilk.startTime < 10*1000)&&blinker){
        fill(#000000);
        textSize(16);
        textAlign(RIGHT);
        text("Press 't' for two player", width - 5, 20);
      }
      break;
  }//End switch(pauseMode)
}//End draw()

void stop(){
  minim.stop();
  super.stop();
}  



int currentLevelNum;
void loadLevel(int ln){
  switch(ln){
    case 1:
      cLevel = level1Creator();
      currentLevelNum = 1;
      break;
    //End case 1
    case 2:
      cLevel = level2Builder();
      currentLevelNum = 2;
      break;
    //End case 2
    case 3:
      cLevel = level3Builder();
      currentLevelNum = 3;
      break;
    case 4:
      cLevel = level4Builder();
      currentLevelNum = 4;
      break;
    //More cases
    default:
      //Do nothing
      break;
    //End default
  }//End switch(ln)
    
  cPlayer1 = cLevel.p1;  
  cPlayer2 = cLevel.p2;
  cMilk = cLevel.milk;
  cBlockList = cLevel.wBlockList;
}//End loadLevelVars(int ln)
