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
        currSpace.setStrokeColor(#FFFFFF);
        currSpace.setDrawable(false);
        grid[i][j] = currSpace;
        gridList.add(currSpace);
        add(currSpace);
      }//End i for-loop
    }//End j for-loop        
  }//End constructor
  
  void load(int x, int y){
    Block currBlock = new Block();
    currBlock.setStatic(false);
    currBlock.setPosition(grid[x][y].getX(), grid[x][y].getY()-1);
    
    wBlockList.add(currBlock);
    add(currBlock);
  }
  
  void putIn(Block b){
    add(b);
    wBlockList.add(b);
  }
  void takeOut(Block b){
    remove(b);
    wBlockList.remove(b);
  }
  void putIn(Player p){
    add(p);
    add(p.crotch);
  }
  void takeOut(Player p){
    remove(p);
    remove(p.crotch);
  }
  
}//End class Level
