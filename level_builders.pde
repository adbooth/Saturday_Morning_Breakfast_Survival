Level level1Creator(){
  Level l = new Level(1*60*1000);    //1 minutes
  //Makes border
  border(l, false, 0,0);
  
  //Add blocks
  l.load(18,18);
  l.load(17,18);
  l.load(16,18);
  l.load(15,18);
  l.load(6,18);
  l.load(18,17);
  l.load(17,17);
  l.load(16,17);
  l.load(18,16);
  l.load(17,16);
  l.load(12,18);
  
  FBox e = new FBox(width, tileSize);
  e.setPosition(width/2, 2.5*tileSize);
  e.setSensor(true);
  e.setStatic(true);
  e.setDrawable(false);
  l.endSensor = e;
  l.add(e);  
  
  //Make players
  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(width/3, height - 2*tileSize);
  l.p2.setPosition(width/3, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l;
}//End level1Builder()



Level level2Builder(){
  Level l = new Level(2*60*1000);    //2 minutes
  //Add borders
  border(l, true, 9, 10);    //Adds bottom around border
  
  //Add blocks
  for(int i = 1; i < 15; i++){
    for(int j = 18; j >= 11; j--){
      l.load(i, j);
    }
  }
  
  //Add endSensor
  FBox e = new FBox(width, tileSize);
  e.setPosition(width/2, 2.5*tileSize);
  e.setSensor(true);
  e.setStatic(true);
  e.setDrawable(true);
  l.endSensor = e;
  l.add(e);
  
  FPoly e2 = new FPoly();
  
  

  l.p1 = new Player(true);
  l.p2 = new Player(false);
  //set starting positions
  l.p1.setPosition(width - 2*tileSize, height - 2*tileSize);
  l.p2.setPosition(width - 2*tileSize, height - 2*tileSize);
  //add player 1
  l.putIn(l.p1);
  l.twoIn = false;
  
  return l;
}//End level2Builder()







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
}
