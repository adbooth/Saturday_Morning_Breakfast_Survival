Level level1Creator(){
  Level l = new Level(int(3.5*60*1000));    //3.5 minutes
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



Level level2Builder(){
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

Level level3Builder(){
  Level l = new Level(3*60*1000);    //2 minutes
  //Add borders
  border(l, true, 17, 18);
  FBox ledge = new FBox(7*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(#529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(4.5*tileSize, 11.5*tileSize);
  l.add(ledge);
  
  ledge = new FBox(8*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(#529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(15*tileSize, 11.5*tileSize);
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

Level level4Builder(){
  Level l = new Level(3*60*1000);
  border(l, true, 0, 1);
  FBox ledge = new FBox(10*tileSize, tileSize);
  ledge.setGrabbable(false);
  ledge.setStatic(true);
  ledge.setNoStroke();
  ledge.setFillColor(#529FD1);
  ledge.setRestitution(0);
  ledge.setFriction(1);
  ledge.setPosition(8*tileSize, 11.5*tileSize);
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
  l.p1.setPosition(7.5*tileSize, height - 2*tileSize);
  l.p2.setPosition(6.5*tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l; 
}







void border(Level l, boolean t, int s, int f){  //Range: 2-17
  FPoly b = new FPoly();
  if(t){
    b.vertex(tileSize, 3*tileSize);
    b.vertex(s*tileSize, 3*tileSize);
    b.vertex(s*tileSize, 4*tileSize);
    b.vertex(tileSize, 4*tileSize);
    b.setStatic(true);
    b.setNoStroke();
    b.setFillColor(#529FD1);
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
    b.setFillColor(#529FD1);
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
  b.setFillColor(#529FD1);
  b.setRestitution(0);
  b.setFriction(1);
  l.add(b);
}//End border()

FPoly uShapedSensor(int x){
  FPoly e = new FPoly();
  e.vertex(0, tileSize*2.5);
  e.vertex(0, tileSize*-2);
  e.vertex(width, tileSize*-2);
  e.vertex(width, tileSize*2.5);
  e.vertex(tileSize*(x+5), tileSize*2.5);
  e.vertex(tileSize*(x+5), -tileSize);
  e.vertex(tileSize*(x+1), -tileSize);
  e.vertex(tileSize*(x+1), tileSize*2.5);
  e.setSensor(true);
  e.setStatic(true);
  e.setStrokeColor(#00FF00);
  e.setNoFill();
  e.setDrawable(false);
  return e;
}//End uShapedSensor()
