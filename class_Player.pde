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
    breathPortion = 0.0;
    
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
    setRestitution(.01);
    setFriction(10);
    setGroupIndex(-1);
    
    //Crotch setup
    crotch = new FCircle(.5);
    crotch.setSensor(true);
    crotch.setRotatable(false);
    crotch.setNoStroke();
    crotch.setFillColor(#FFFFFF);
    crotch.setDrawable(false);
  }//End contructor
  
  boolean footUp;
  void update(Milk milk){
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
      setDamping(2.5);
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
      breathPortion = (millis() - underStart)/float(breath);
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
    
    //Crotch location updating
    crotch.setPosition(getX(), getY()+getHeight()/4);
        
    if(abs(getVelocityY() - 0) < 0.1){
      jumpable1 = true;
      jumpable2 = true;
    }
    
    pSubmerged = isSubmerged;
  }//End update()
  
  void jump(){
    if(jumpable2){
      setVelocity(getVelocityX(),-getJumpVel());
      jumpable2 = jumpable1;
      jumpable1 = !jumpable1;
    }
  }
  
  void pickUp(){
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
                  }//End below block checking
                }else if(leftDown){
                  if((currBlock.iDex == i-1)&&(currBlock.jDex == j)&&(!currBlock.isHeld)){
                    currBlock.holdingPlayer = this;
                    currBlock.isHeld = true;
                    heldBlock = currBlock;
                    hasBlock = true;
                  }//End below block checking
                }else if(rightDown){
                  if((currBlock.iDex == i+1)&&(currBlock.jDex == j)&&(!currBlock.isHeld)){
                    currBlock.holdingPlayer = this;
                    currBlock.isHeld = true;
                    heldBlock = currBlock;
                    hasBlock = true;
                  }//End below block checking                  
                }//End rightDown/leftDown
              }//End blockList for loop
            }//End currSpace if
          }//End i for loop
        }//End j for loop
      }//End crotch if
    }//End gridList for loop
  }//End pickUp()
      
  void putDown(){
    adjustPosition(0,-heldBlock.getHeight());
    heldBlock.adjustPosition(0,getHeight());
    
    heldBlock.holdingPlayer = null;
    heldBlock.isHeld = false;
    heldBlock = null;
    hasBlock = false;
  }//End putDown()
  
  float getJumpVel(){
    if(hasBlock){
      //Player has a block
      return 300;
    }else{
      //Player doesn't have a block
      return 250;
    }
  }
}//End class Player
