boolean helpMenuOn = false; 

void keyPressed(){
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



void keyReleased(){
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
