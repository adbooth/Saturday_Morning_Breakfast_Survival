import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import fisica.util.nonconvex.*; 
import fisica.*; 
import ddf.minim.*; 
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SMBS extends PApplet {

//
//Andrew Booth
//DMS 110
//Final Project
//Saturday Morning Breakfast Survival
//

//fisica imports



//Minim imports/stuff




Minim minim;
AudioPlayer jumpNoise;
AudioPlayer liftNoise;
AudioPlayer placeNoise;

int tileSize = 32;
int KonamiCounter;

public void setup(){
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

public void draw(){
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
      background(0xff99D1F5);
      fill(0xff2AE884);
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
      background(0xff99D1F5);
      fill(0xff2AE884);
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
        fill(0xffF51119);
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
          fill(0xffF51119);
          textAlign(LEFT);
          text("Stack the Tini Wheats to get out of the bowl and escape the rising milk!", 3.5f*tileSize - 10, 4.5f*tileSize);
          fill(0xffF5AD11);
          triangle(2.5f*tileSize, 3.5f*tileSize + 0.5f*tileSize*sin(frameCount/frameRate), 2*tileSize, 4*tileSize + 0.5f*tileSize*sin(frameCount/frameRate), 3*tileSize, 4*tileSize + 0.5f*tileSize*sin(frameCount/frameRate));          
          rect(2.2f*tileSize, 4*tileSize - 1 + 0.5f*tileSize*sin(frameCount/frameRate), 0.6f*tileSize, tileSize);
        }
      }
      
      if((millis() - cMilk.startTime < 10*1000)&&blinker){
        fill(0xff000000);
        textSize(16);
        textAlign(RIGHT);
        text("Press 't' for two player", width - 5, 20);
      }
      break;
  }//End switch(pauseMode)
}//End draw()

public void stop(){
  minim.stop();
  super.stop();
}  



int currentLevelNum;
public void loadLevel(int ln){
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
class Block extends FBox{
  FLine topLine;
  Player holdingPlayer;
  boolean isHeld;
  
  int iDex;
  int jDex;

  Block(){
    super(0,0);
    holdingPlayer = null;
    isHeld = false;
    //Set size (always square)
    setWidth(tileSize);
    setHeight(getWidth());
    //other features
    setRotatable(false);
    setDensity(1);
    setRestitution(0);
    setFriction(1);
    setGrabbable(false);
    
    if(PApplet.parseInt(random(2)) == 0){
      attachImage(blockImages[0]);
    }else{
      attachImage(blockImages[1]);
    }
  }//End constructor
  
  
  public void update(){
    //Update positon depending on condition
    if(isHeld){
      setPosition(holdingPlayer.getX(),holdingPlayer.getY()-(getHeight()+holdingPlayer.getHeight())/2);
      setDensity(1);
    }else{
      for(FBox currSpace : gridList){
        if((currSpace.getX()-currSpace.getWidth()/2 <= getX())&&(getX() <= currSpace.getX()+currSpace.getWidth()/2)){
          setVelocity(0,getVelocityY());
          setPosition(currSpace.getX(), getY());
          if((currSpace.getY()-currSpace.getHeight()/2 <= getY())&&(getY() <= currSpace.getY()+currSpace.getHeight()/2)){
            for(int j = 0; j < 20; j++){
              for(int i = 0; i < 20; i++){
                if(currSpace == grid[i][j]){
                  iDex = i;
                  jDex = j;
                }//End currSpace if
              }//End i for loop
            }//End j for loop
          }//End y contain if
        }//End x contain if
      }//End gridList for loop
      setDensity(500);
    }//End if(isHeld)
  }//End update() 

}//End class Block
ArrayList<FBox> gridList = new ArrayList<FBox>();
FBox[][] grid = new FBox[20][20];

class Level extends FWorld{
  ArrayList<Block> wBlockList = new ArrayList<Block>();
  FBody border;
  Player p1;
  Player p2;
  boolean twoIn;
  
  Milk milk;
  
  FBody endSensor;
    
  Level(int u){
    super();
    setGravity(0, 380);
    setEdges(-6,0,width+6,height+5);
    remove(top);
    
    milk = new Milk(millis(), u);
        
    //Make grid
    FBox currSpace;
    for(int j = 0; j < 20; j++){
      for(int i = 0; i < 20; i++){
        currSpace = new FBox(tileSize,tileSize);
        currSpace.setGrabbable(false);
        currSpace.setStatic(true);
        currSpace.setSensor(true);
        currSpace.setPosition(32*i+16,32*j+16);
        currSpace.setNoStroke();
        currSpace.setNoFill();
        currSpace.setStrokeColor(0xffFFFFFF);
        currSpace.setDrawable(false);
        grid[i][j] = currSpace;
        gridList.add(currSpace);
        add(currSpace);
      }//End i for-loop
    }//End j for-loop        
  }//End constructor
  
  public void load(int x, int y){
    Block currBlock = new Block();
    currBlock.setStatic(false);
    currBlock.setPosition(grid[x][y].getX(), grid[x][y].getY()-1);
    
    wBlockList.add(currBlock);
    add(currBlock);
  }
  
  public void putIn(Block b){
    add(b);
    wBlockList.add(b);
  }
  public void takeOut(Block b){
    remove(b);
    wBlockList.remove(b);
  }
  public void putIn(Player p){
    add(p);
    add(p.crotch);
  }
  public void takeOut(Player p){
    remove(p);
    remove(p.crotch);
  }
  
}//End class Level
class Milk {
  //Timing data
  int startTime;
  int ultimatum;
  int millSince;
  //for pauses
  int pauseStart;
  boolean milkPaused;
  
  //Sizing data
  int tall;
  int tly;
  int x = 0;
  int wide = width;
    
  Milk(int s, int u){
    startTime = s;
    ultimatum = u;
  }//End constructor
  
  public void update(){
    if(!milkPaused){
      millSince = millis()-startTime;
      if(tly > 2.5f*tileSize){
        tall = millSince*height/ultimatum;
      }
      tly = height-tall;
    }
    noStroke();
    fill(0xffFFFFFF, 100);
    rect(x,tly,wide,tall);    
  }
  
  public void setPaused(boolean p){
    milkPaused = p;
    if(milkPaused){
      pauseStart = millis();
    }else{
      startTime = startTime + millis() - pauseStart;
      ultimatum = ultimatum + millis() - pauseStart;
    }
  }
  
  public int getY(){
    return tly;
  }
}//End class Milk
class Player extends FBox{  
  FWorld currWorld;
  FCircle crotch;
  
  Block heldBlock;
  boolean hasBlock;
  
  PImage[] playerImage;
  
  boolean jumpable1, jumpable2;
  boolean leftDown, rightDown;
  int LDTime, RDTime;
  
  boolean isSubmerged;
  boolean pSubmerged;
  int underStart;
  int breath = 15*1000;  //15 seconds
  boolean isDead = false;
  float breathPortion;
  
  boolean firstPlayer;
  
  int moveVel = 150;
  
  Player(boolean f){
    super(0,0);
    firstPlayer = f;
    
    hasBlock = false;
    breathPortion = 0.0f;
    
    if(f){
      playerImage = player1Image;
    }else{
      playerImage = player2Image;
    }
    //set size
    setWidth(tileSize-8);
    setHeight(2*tileSize - 2);
    
    //other settings
    setRotatable(false);
    setDensity(1);
    setRestitution(.01f);
    setFriction(10);
    setGroupIndex(-1);
    setGrabbable(false);
    
    //Crotch setup
    crotch = new FCircle(.5f);
    crotch.setSensor(true);
    crotch.setRotatable(false);
    crotch.setNoStroke();
    crotch.setFillColor(0xffFFFFFF);
    crotch.setDrawable(false);
  }//End contructor
  
  boolean footUp;
  public void update(Milk milk){
    if(frameCount%15 == 0){footUp = !footUp;}
    if(!hasBlock){
      if(!jumpable1){
        attachImage(playerImage[6]);
      }else{
        if(leftDown||rightDown){
          if(footUp){
            attachImage(playerImage[2]);
          }else{
            attachImage(playerImage[3]);
          }
        }else{
          attachImage(playerImage[0]);
        } 
      }
    }else{
      if(!jumpable1){
        attachImage(playerImage[7]);
      }else{
        if(leftDown||rightDown){
          if(footUp){
            attachImage(playerImage[4]);
          }else{
            attachImage(playerImage[5]);
          }
        }else{
          attachImage(playerImage[1]);
        } 
      }
    }
    
    if(getY() > milk.getY()){
      setDamping(2.5f);
      isSubmerged = true;
    }else{
      setDamping(1);
      isSubmerged = false;
    }
    if(isSubmerged){
      if(!pSubmerged){
        underStart = millis();
      }
      if(underStart + breath < millis()){
        isDead = true;
      }
      breathPortion = (millis() - underStart)/PApplet.parseFloat(breath);
      if(!isDead){
        if(firstPlayer){
          stroke(breathPortion*255, 255 - breathPortion*255, 0);
          noFill();          
          rect(50, height/3, 15, 100);
          noStroke();
          fill(breathPortion*255, 255 - breathPortion*255, 0);
          rect(50, height/3 + breathPortion*100, 15, 100 - breathPortion*100);
        }else{
          if(cLevel.twoIn){
            stroke(breathPortion*255, 255 - breathPortion*255, 0);
            noFill();          
            rect(height - 65, height/3, 15, 100);
            noStroke();
            fill(breathPortion*255, 255 - breathPortion*255, 0);
            rect(height - 65, height/3 + breathPortion*100, 15, 100 - breathPortion*100);
          }//End if(cLevel.twoIn)
        }//End if(firstPlayer)
      }//End if(!isDead)
    }//End if(isSubmerged)
    
    //Left/right movement control
    if(!isDead){
      if(leftDown||rightDown){
        setFriction(0);
      }else{
        setFriction(10);
      }
      if(leftDown){ 
        setVelocity(-moveVel,getVelocityY());
      }
      if(rightDown){
        setVelocity(moveVel,getVelocityY());
      }
      if(leftDown&&rightDown){
        setVelocity(0, getVelocityY());
      }
    }
    
    //Crotch location updating
    crotch.setPosition(getX(), getY()+getHeight()/4);
        
    if(abs(getVelocityY() - 0) < 0.1f){
      jumpable1 = true;
      jumpable2 = true;
    }
    
    pSubmerged = isSubmerged;
  }//End update()
  
  public void jump(){
    if(jumpable2&&!isDead){
      setVelocity(getVelocityX(),-getJumpVel());
      jumpable2 = jumpable1;
      jumpable1 = !jumpable1;
      jumpNoise.rewind();
      jumpNoise.play();
    }
  }
  
  public void pickUp(){
    for(FBox currSpace : gridList){
      if(crotch.isTouchingBody(currSpace)){
        for(int j = 0; j < 20; j++){
          for(int i = 0; i < 20; i++){
            if(currSpace == grid[i][j]){
              for(Block currBlock : cBlockList){
                if((leftDown&&rightDown)||!(leftDown||rightDown)){
                  if((currBlock.iDex == i)&&(currBlock.jDex == j+1)&&(!currBlock.isHeld)){
                    currBlock.holdingPlayer = this;
                    currBlock.isHeld = true;
                    heldBlock = currBlock;
                    hasBlock = true;
                    liftNoise.rewind();
                    liftNoise.play();
                  }//End below block checking
                }else if(leftDown){
                  if((currBlock.iDex == i-1)&&(currBlock.jDex == j)&&(!currBlock.isHeld)){
                    currBlock.holdingPlayer = this;
                    currBlock.isHeld = true;
                    heldBlock = currBlock;
                    hasBlock = true;
                    liftNoise.rewind();
                    liftNoise.play();
                  }//End below block checking
                }else if(rightDown){
                  if((currBlock.iDex == i+1)&&(currBlock.jDex == j)&&(!currBlock.isHeld)){
                    currBlock.holdingPlayer = this;
                    currBlock.isHeld = true;
                    heldBlock = currBlock;
                    hasBlock = true;
                    liftNoise.rewind();
                    liftNoise.play();
                  }//End below block checking                  
                }//End rightDown/leftDown
              }//End blockList for loop
            }//End currSpace if
          }//End i for loop
        }//End j for loop
      }//End crotch if
    }//End gridList for loop
  }//End pickUp()
      
  public void putDown(){
    adjustPosition(0,-heldBlock.getHeight());
    heldBlock.adjustPosition(0,getHeight());
    
    heldBlock.holdingPlayer = null;
    heldBlock.isHeld = false;
    heldBlock = null;
    hasBlock = false;
    placeNoise.rewind();
    placeNoise.play();
  }//End putDown()
  
  public float getJumpVel(){
    if(hasBlock){
      //Player has a block
      return 300;
    }else{
      //Player doesn't have a block
      return 250;
    }
  }
}//End class Player
PImage[] blockImages = new PImage[2];
PImage[] player1Image = new PImage[8];
PImage[] player2Image = new PImage[8];
PImage[] levelImage = new PImage[4];

public void imageImporter(){
  //Block images
  blockImages[0] = loadImage("frostedMiniWheat.png");
  blockImages[1] = loadImage("unfrostedMiniWheat.png");
  
  //Player 1 images
  player1Image[0] = loadImage("player1Standing.png");
  player1Image[1] = loadImage("player1StandingWithBlock.png");
  player1Image[2] = loadImage("player1Walking0.png");
  player1Image[3] = loadImage("player1Walking1.png");
  player1Image[4] = loadImage("player1WalkingWithBlock0.png");
  player1Image[5] = loadImage("player1WalkingWithBlock1.png");
  player1Image[6] = loadImage("player1Jumping.png");
  player1Image[7] = loadImage("player1JumpingWithBlock.png");
  
  //Player 2 images
  player2Image[0] = loadImage("player2Standing.png");
  player2Image[1] = loadImage("player2StandingWithBlock.png");
  player2Image[2] = loadImage("player2Walking0.png");
  player2Image[3] = loadImage("player2Walking1.png");
  player2Image[4] = loadImage("player2WalkingWithBlock0.png");
  player2Image[5] = loadImage("player2WalkingWithBlock1.png");
  player2Image[6] = loadImage("player2Jumping.png");
  player2Image[7] = loadImage("player2JumpingWithBlock.png");
  
  //Level images
  levelImage[0] = loadImage("level1Screenshot.png");
  levelImage[1] = loadImage("level2Screenshot.png");
  levelImage[2] = loadImage("level3Screenshot.png");
  levelImage[3] = loadImage("level4Screenshot.png");  
}//End imageImporter()

boolean helpMenuOn = false; 

public void keyPressed(){
  switch(pauseMode){
    case 0:    //Beginning pause ***************************************************************
      switch(key){
        case ' ':
          loadLevel(maxLevel);
          pauseMode = 10;
          break;
        //End case ' '
        case '1':
          loadLevel(1);
          pauseMode = 10;
          break;
        //End case '1'
        case '2':
          if(maxLevel >= 2){
            loadLevel(2);
            pauseMode = 10;
          }
          break;
        //End case '2'
        case '3':
          if(maxLevel >= 3){
            loadLevel(3);
            pauseMode = 10;
          }
          break;
        //End case '3'
        case '4':
          if(maxLevel >= 4){
            loadLevel(4);
            pauseMode = 10;
          }
          break;
        //End case '4'
        case 'h':
        case 'H':
          helpMenuOn = !helpMenuOn;
          break;
        default:
          //Load no level
          break;
        //End default
      }//End switch(key)
      switch(KonamiCounter){
        case 0:
          if((key == CODED)&&(keyCode == UP)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 0
        case 1:
          if((key == CODED)&&(keyCode == UP)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 1
        case 2:
          if((key == CODED)&&(keyCode == DOWN)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 2
        case 3:
          if((key == CODED)&&(keyCode == DOWN)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 3
        case 4:
          if((key == CODED)&&(keyCode == LEFT)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 4
        case 5:
          if((key == CODED)&&(keyCode == RIGHT)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 5
        case 6:
          if((key == CODED)&&(keyCode == LEFT)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 6
        case 7:
          if((key == CODED)&&(keyCode == RIGHT)){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 7
        case 8:
          if((key == 'b')||(key == 'B')){
            KonamiCounter++;
          }else{
            KonamiCounter = 0;
          }
          break;
        //End case 8
        case 9:
          if((key == 'a')||(key == 'A')){
            maxLevel = finalLevel;
            KonamiCounter = 0;
          }
        default:
          break;
        //End default
      }//End switch(KonamiCounter)
      break;
    //End case 0
    case 1:    //Level finish pause ************************************************************
      if(key == ' '){
        currentLevelNum++;
        loadLevel(currentLevelNum);
        pauseMode = 10;
      }
      if(key == BACKSPACE){
        pauseMode = 0;
      }
      break;
    //End case 1
    case 2:    //Mid-game pause ****************************************************************
      if((key == ' ')||(key == 'p')||(key == 'P')){
        cMilk.setPaused(false);
        pauseMode = 10; 
      }
      if(key == BACKSPACE){
        pauseMode = 0;
      }
      if((key == 'r')||(key == 'R')){
        loadLevel(currentLevelNum);
        pauseMode = 10;
      }
      break;
    //End case 2
    case 3:    //Gameover **********************************************************************
      if(key == ' '){
        loadLevel(currentLevelNum);
        pauseMode = 10;
      }
      if(key == BACKSPACE){
        pauseMode = 0;
      }
      break;
    //End case 3
    default:    //Game is running **************************************************************
      switch(key){
        case 'j':
        case 'J':
          Block temp = new Block();
          temp.setPosition(grid[1][3].getX()+1,grid[1][3].getY());
          cLevel.putIn(temp);
          break;
        //End case 'J'
        case 'p':
        case 'P':
          cMilk.setPaused(true);
          pauseMode = 2;
          break;
        //End case 'P'
        case 't':
        case 'T':
          if(millis() - cLevel.milk.startTime < 10*1000){
            if(!cLevel.twoIn){
              cLevel.putIn(cPlayer2);
            }else{
              cLevel.takeOut(cPlayer2);
            }
            cLevel.twoIn = !cLevel.twoIn;
          }
          break;
        //End case 'T'
        case 'w':
        case 'W':
          //Jump
          cPlayer1.jump();
          break;
        //End case 'W'
        case 's':
        case 'S':
          //Pick up block
          if(!cPlayer1.hasBlock){
            cPlayer1.pickUp();
          }else{
            cPlayer1.putDown();
          }
          break;
        //End case 'S'
        case 'a':
        case 'A':
          cPlayer1.leftDown = true;
          cPlayer1.LDTime = millis();
          break;
        //End case 'A'
        case 'd':
        case 'D':
          cPlayer1.rightDown = true;
          cPlayer1.RDTime = millis();
          break;
        //End case 'D'
        case CODED:    //Coded layer starts here. Nested switches can be tricky
          switch(keyCode){
            //More cases
            case UP:
              cPlayer2.jump();
              break;
            //End case UP
            case DOWN:
              //Pick up block
              if(!cPlayer2.hasBlock){
                cPlayer2.pickUp();
              }else{
                cPlayer2.putDown();
              }          
              break;
            //End case DOWN
            case LEFT:
              cPlayer2.leftDown = true;
              break;
            //End case LEFT
            case RIGHT:
              cPlayer2.rightDown = true;
              break;
            //End case RIGHT
            default:
              break;
            //End default
          }//End switch(keyCode)
          break;
        //End case CODED
        default:
          break;
        //End default
      }//End switch(key)
      break;
    //End default
  }//End switch(pauseMode);
}//End keyPressed()



public void keyReleased(){
  if(pauseMode > 3){
    switch(key){
      case 'a':
      case 'A':
        cPlayer1.leftDown = false;
        break;
      //End case 'A'
      case 'd':
      case 'D':
        cPlayer1.rightDown = false;
        break;
      //End case 'D'
      case CODED:
        if(keyCode == LEFT){
          cPlayer2.leftDown = false;
        }
        if(keyCode == RIGHT){
          cPlayer2.rightDown = false;
        }
        break;
      //End case CODED
      default:
        break;
      //End default
    }//End switch(key)
  }
}//End keyReleased()
public Level level1Creator(){
  Level l = new Level(PApplet.parseInt(3.5f*60*1000));    //3.5 minutes
  //Makes border
  border(l, true, 1, 4);
    
  //Add triangular stack of blocks
  for(int i = 15; i >= 8; i--){
    for(int j = 18; j >= i; j--){
      l.load(i-7,j);
    }
  }
  
  //Add misc. blocks
  l.load(4,10);
  l.load(5,11);
  l.load(6,12);
  l.load(7,13);
  l.load(8,14);
  l.load(9,18);
  
  l.load(18,18);
  l.load(17,18);
  l.load(16,18);
  l.load(15,18);
  l.load(18,17);
  l.load(17,17);
  l.load(16,17);
  l.load(18,16);
  l.load(17,16);
  
  //Make and add end sensor
  l.endSensor = uShapedSensor(0);
  l.add(l.endSensor);
  
  //Make players
  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(2*width/3, height - 2*tileSize);
  l.p2.setPosition(2*width/3 - tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l;
}//End level1Builder()



public Level level2Builder(){
  Level l = new Level(2*60*1000);    //2 minutes
  //Add borders
  border(l, true, 9, 10);    //Adds bottom around border
  
  //Add blocks as big rectangular pile
  for(int i = 1; i < 15; i++){
    for(int j = 18; j >= 11; j--){
      l.load(i, j);
    }
  }
  
  //Make and add end sensor
  l.endSensor = uShapedSensor(7);
  l.add(l.endSensor);

  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(width - 2*tileSize, height - 2*tileSize);
  l.p2.setPosition(width - 3*tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l;
}//End level2Builder()

public Level level3Builder(){
  Level l = new Level(3*60*1000);    //2 minutes
  //Add borders
  border(l, true, 17, 18);
  FBox ledge = new FBox(7*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(0xff529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(4.5f*tileSize, 11.5f*tileSize);
  l.add(ledge);
  
  ledge = new FBox(8*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(0xff529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(15*tileSize, 11.5f*tileSize);
  l.add(ledge);
  
  for(int i = 1; i <= 6; i++){
    for(int j = 10; j >= i+4; j--){
      l.load(i,j);
    }
  }
  for(int i = 1; i <= 6; i++){
    for(int j = 18; j >= i+12; j--){
      l.load(i,j);
    }
  }  
  
  //Make and add endSensor
  l.endSensor = uShapedSensor(14);
  l.add(l.endSensor);
  
  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(width/2, height - 2*tileSize);
  l.p2.setPosition(width/2 - tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l;
}//End level3Builder()

public Level level4Builder(){
  Level l = new Level(3*60*1000);
  border(l, true, 0, 1);
  FBox ledge = new FBox(10*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(0xff529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(8*tileSize, 11.5f*tileSize);
  l.add(ledge);
  
  //Add blocks
  for(int i = 1; i <= 6; i++){
    for(int j = 18; j >= i+13; j--){
      l.load(i,j);
    }
  }
  for(int i = 9; i <= 18; i++){
    for(int j = 18; j >= 27-i; j--){
      l.load(i,j);
    }
  }
  //make little pyramid (first layer)
  l.load(6,10);
  l.load(7,10);
  l.load(8,10);
  l.load(9,10);
  l.load(10,10);
  //second layer
  l.load(7,9);
  l.load(8,9);
  l.load(9,9);
  //third layer
  l.load(8,8);  
  
  //Make and add end sensor
  l.endSensor = uShapedSensor(0);
  l.add(l.endSensor);
  
  //Player stuff
  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(7.5f*tileSize, height - 2*tileSize);
  l.p2.setPosition(6.5f*tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l; 
}







public void border(Level l, boolean t, int s, int f){  //Range: 2-17
  FPoly b = new FPoly();
  if(t){
    b.vertex(tileSize, 3*tileSize);
    b.vertex(s*tileSize, 3*tileSize);
    b.vertex(s*tileSize, 4*tileSize);
    b.vertex(tileSize, 4*tileSize);
    b.setStatic(true);
    b.setNoStroke();
    b.setFillColor(0xff529FD1);
    b.setRestitution(0);
    b.setFriction(1);
    l.add(b);
    
    b = new FPoly();
    b.vertex((f+1)*tileSize, 3*tileSize);
    b.vertex(width-tileSize, 3*tileSize);
    b.vertex(width-tileSize, 4*tileSize);
    b.vertex((f+1)*tileSize, 4*tileSize);
    b.setStatic(true);
    b.setNoStroke();
    b.setFillColor(0xff529FD1);
    b.setRestitution(0);
    b.setFriction(1);
    l.add(b);
    
    b = new FPoly();    
  }
  
  b.vertex(0, 3*tileSize);
  b.vertex(tileSize, 3*tileSize);
  b.vertex(tileSize, 19*tileSize);
  b.vertex(19*tileSize, 19*tileSize);
  b.vertex(19*tileSize, 3*tileSize);
  b.vertex(width, 3*tileSize);
  b.vertex(width, height);
  b.vertex(0, height);
  b.setStatic(true);
  b.setNoStroke();
  b.setFillColor(0xff529FD1);
  b.setRestitution(0);
  b.setFriction(1);
  l.add(b);
}//End border()

public FPoly uShapedSensor(int x){
  FPoly e = new FPoly();
  e.vertex(0, tileSize*2.5f);
  e.vertex(0, tileSize*-2);
  e.vertex(width, tileSize*-2);
  e.vertex(width, tileSize*2.5f);
  e.vertex(tileSize*(x+5), tileSize*2.5f);
  e.vertex(tileSize*(x+5), -tileSize);
  e.vertex(tileSize*(x+1), -tileSize);
  e.vertex(tileSize*(x+1), tileSize*2.5f);
  e.setSensor(true);
  e.setStatic(true);
  e.setStrokeColor(0xff00FF00);
  e.setNoFill();
  e.setDrawable(false);
  return e;
}//End uShapedSensor()
public void startMenu(int l){
  background(0xffFFFFFF);
  noStroke();
  fill(0xffCB2D45);
  rect(-3, height/3, width+6, height/3);
  
  textAlign(CENTER);
  textSize(37);
  text("Saturday Morning Breakfast Survival", width/2, height/3);
  
  fill(0xffFFFFFF);
  textSize(24);
  text("Stack the cereal to survive!", width/2, height/3 + 18);
  
  int imageSize = 120;
  int gap = (width - imageSize*maxLevel)/(maxLevel+1);
  int imageTop = 250;
  for(int i = 0; i < maxLevel; i++){
    noStroke();
    fill(0xffEA899A);
    rect(gap*(i+1) + imageSize*i - 5, imageTop - 5, imageSize + 10, imageSize + 10, 5);
    image(levelImage[i], gap*(i+1) + imageSize*i, imageTop, imageSize, imageSize);
    fill(0xffFFFFFF);
    textAlign(CENTER);
    textSize(16);
    text("Level "+ (i+1), gap*(i+1) + imageSize*i + imageSize/2, imageTop + imageSize + 20);
  }
  
  textAlign(CENTER);
  textSize(16);  
  fill(0xffFFFFFF);
  text("Press SPACEBAR to continue, or hit a NUMBER KEY to select an unlocked level", width/2, 2*height/3);
  
  textAlign(RIGHT);
  textSize(16);
  fill(0xffCB2D45);
  text("A game by Andrew Booth", width-2, height-4);
  
  textAlign(LEFT);
  textSize(16);
  fill(0xffCB2D45);
  text("Press 'h' for how to play", 2, height-4);
  
  if(helpMenuOn){
    background(0xffFFFFFF);
    textAlign(LEFT);
    textSize(16);
    fill(0xffCB2D45);
    text("You're trapped in a bowl of Tini-Wheats!", 5, 25); 
    text("Stack them to escape drowning in the ever-filling milk!", 5, 40);
    
    noStroke();
    fill(0xffCB2D45);
    rect(-1, 50, width+2, 150);
    
    fill(0xffFFFFFF);
    text("Controls:", 5, 70);
    textSize(12);
    text("P - Pause", 5, 85);
    text("A - move left", 5, 110);
    text("D - move right", 5, 125);
    text("W - jump", 5, 140);
    text("S - pick up block", 5, 155);
    text("Pick up a block while pressing LEFT or RIGHT to pick up a block next to you", 4, 180);
    
    fill(0xffCB2D45);
    text("H - go back", 5, height - 4);
    
    
    
  }
}//End startMenu

public void levelFinishMenu(){
  noStroke();
  fill(0xff2AE884);
  rect(-3, height/3, width + 6, height/3);  
  
  fill(0xffFFFFFF);
  textAlign(CENTER);
  textSize(32);
  text("You escaped!", width/2, height/2);
  textSize(16);
  text("Press BACKSPACE to go back, or SPACEBAR to continue to the next level", width/2, height/2 + 15);      
}

public void midGamePauseMenu(){
  noStroke();
  fill(0xffF5F770);
  rect(-3, 2*height/5, width + 6, height/5 - 5);
  
  fill(0xff000000);
  textAlign(CENTER);
  textSize(16);
  text("Press 'p' or SPACEBAR to continue", width/2, height/2 - 25);
  text("Press BACKSPACE to go back", width/2, height/2);
  text("Press 'r' to reset the level", width/2, height/2 + 25);
}

public void gameoverMenu(){
  noStroke();
  fill(0xffCB2D45);
  rect(-3, height/3, width + 6, height/3);
  
  fill(0xffFFFFFF);
  textAlign(CENTER);
  textSize(32);
  text("You lost! LOL", width/2, height/2);
  textSize(16);
  text("Press BACKSPACE to go back, or SPACEBAR to try again", width/2, height/2 + 15);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "SMBS" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
