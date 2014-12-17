void startMenu(int l){
  background(#FFFFFF);
  noStroke();
  fill(#CB2D45);
  rect(-3, height/3, width+6, height/3);
  
  textAlign(CENTER);
  textSize(37);
  text("Saturday Morning Breakfast Survival", width/2, height/3);
  
  fill(#FFFFFF);
  textSize(24);
  text("Stack the cereal to survive!", width/2, height/3 + 18);
  
  int imageSize = 120;
  int gap = (width - imageSize*maxLevel)/(maxLevel+1);
  int imageTop = 250;
  for(int i = 0; i < maxLevel; i++){
    noStroke();
    fill(#EA899A);
    rect(gap*(i+1) + imageSize*i - 5, imageTop - 5, imageSize + 10, imageSize + 10, 5);
    image(levelImage[i], gap*(i+1) + imageSize*i, imageTop, imageSize, imageSize);
    fill(#FFFFFF);
    textAlign(CENTER);
    textSize(16);
    text("Level "+ (i+1), gap*(i+1) + imageSize*i + imageSize/2, imageTop + imageSize + 20);
  }
  
  textAlign(CENTER);
  textSize(16);  
  fill(#FFFFFF);
  text("Press SPACEBAR to continue, or hit a NUMBER KEY to select an unlocked level", width/2, 2*height/3);
  
  textAlign(RIGHT);
  textSize(16);
  fill(#CB2D45);
  text("A game by Andrew Booth", width-2, height-4);
  
  textAlign(LEFT);
  textSize(16);
  fill(#CB2D45);
  text("Press 'h' for how to play", 2, height-4);
  
  if(helpMenuOn){
    background(#FFFFFF);
    textAlign(LEFT);
    textSize(16);
    fill(#CB2D45);
    text("You're trapped in a bowl of Tini-Wheats!", 5, 25); 
    text("Stack them to escape drowning in the ever-filling milk!", 5, 40);
    
    noStroke();
    fill(#CB2D45);
    rect(-1, 50, width+2, 150);
    
    fill(#FFFFFF);
    text("Controls:", 5, 70);
    textSize(12);
    text("P - Pause", 5, 85);
    text("A - move left", 5, 110);
    text("D - move right", 5, 125);
    text("W - jump", 5, 140);
    text("S - pick up block", 5, 155);
    text("Pick up a block while pressing LEFT or RIGHT to pick up a block next to you", 4, 180);
    
    fill(#CB2D45);
    text("H - go back", 5, height - 4);
    
    
    
  }
}//End startMenu

void levelFinishMenu(){
  noStroke();
  fill(#2AE884);
  rect(-3, height/3, width + 6, height/3);  
  
  fill(#FFFFFF);
  textAlign(CENTER);
  textSize(32);
  text("You escaped!", width/2, height/2);
  textSize(16);
  text("Press BACKSPACE to go back, or SPACEBAR to continue to the next level", width/2, height/2 + 15);      
}

void midGamePauseMenu(){
  noStroke();
  fill(#F5F770);
  rect(-3, 2*height/5, width + 6, height/5 - 5);
  
  fill(#000000);
  textAlign(CENTER);
  textSize(16);
  text("Press 'p' or SPACEBAR to continue", width/2, height/2 - 25);
  text("Press BACKSPACE to go back", width/2, height/2);
  text("Press 'r' to reset the level", width/2, height/2 + 25);
}

void gameoverMenu(){
  noStroke();
  fill(#CB2D45);
  rect(-3, height/3, width + 6, height/3);
  
  fill(#FFFFFF);
  textAlign(CENTER);
  textSize(32);
  text("You lost! LOL", width/2, height/2);
  textSize(16);
  text("Press BACKSPACE to go back, or SPACEBAR to try again", width/2, height/2 + 15);
}
