//
//Andrew Booth
//DMS 110
//Final Project
//Saturday Morning Breakfast Survival
//

//fisica imports
import fisica.util.nonconvex.*;
import fisica.*;

int tileSize = 32;

void setup(){
  size(20*tileSize, 20*tileSize);
  imageImporter();  //Import images
  noCursor();
  
  Fisica.init(this);    //Get fisica running
  
  pauseMode = 0;
}//End setup()



int pauseMode;
int maxLevel = 2;
//Items for level
Level cLevel;
Player cPlayer1, cPlayer2;
Milk cMilk;
ArrayList<Block> cBlockList;

boolean blinker;

void draw(){
//  println(mouseX +", "+ mouseY);
  switch(pauseMode){
    case 0:
      //Beginning pause
      startMenu(maxLevel);
      break;
    case 1:
      //Level finish pause
      if(currentLevelNum == maxLevel){
        maxLevel++;
      }
      background(0);
      cMilk.update();
      cLevel.step();
      cLevel.draw();
      fill(#00FF00);
      textSize(32);
      text("You win!", width/2, height/2);
      textSize(15);
      text("Press backspace to go back, or spacebar to continue", width/2, height/2 + 15);      
      break;
    case 2:
      //Mid-game pause
      textAlign(CENTER);
      fill(#00FF00);
      textSize(24);
      text("Hit space to CONTINUE", width/2, height/5);
      text("Hit backspace to EXIT", width/2, height/5 + 100);
      break;
    case 3:
      //Gameover
      textSize(32);
      fill(#00FF00);
      text("Game over", width/2, height/2);
      textSize(16);
      text("Press backspace to go back, or spacebar to try again", width/2, height/2 + 15);
      break;
    default:
      //Game is running, update stuff
      background(0);
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
        if(cLevel.endSensor.isTouchingBody(cPlayer1)||cLevel.endSensor.isTouchingBody(cPlayer2)){
          pauseMode = 1;
        }else if(cPlayer1.isDead&&cPlayer2.isDead){
          pauseMode = 3;
        }
      }else{
        //One player
        if(cLevel.endSensor.isTouchingBody(cPlayer1)){
          pauseMode = 1;
        }else if(cPlayer1.isDead){
          pauseMode = 3;
        }
      }
      
      cPlayer1.update(cMilk);
      cPlayer2.update(cMilk);
      
      if((millis() - cLevel.milk.startTime < 10*1000)&&blinker){
        fill(#00FF00);
        textSize(16);
        textAlign(RIGHT);
        text("Press 't' for two player", width - 5, 20);
        textAlign(CENTER); 
      }
      break;
  }//End switch(pauseMode)
}//End draw()



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



void keyPressed(){
  switch(pauseMode){
    case 0:
      //Beginning pause
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
        default:
          //Load no level
          break;
        //End default
      }//End switch(key)
      break;
    //End case 0
    case 1:
      //Level finish pause
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
    case 2:
      //Mid-game pause
      if(key == ' '){
        cMilk.setPaused(false);
        pauseMode = 10; 
      }
      if(key == BACKSPACE){
        pauseMode = 0;
      }      
      break;
    //End case 2
    case 3:
      //Gameover
      if(key == ' '){
        loadLevel(currentLevelNum);
        pauseMode = 10;
      }
      if(key == BACKSPACE){
        pauseMode = 0;
      }
      break;
    //End case 3
    default:
      //Game is running
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



void keyReleased(){
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
}//End keyReleased()
