PImage[] blockImages = new PImage[2];
PImage[] player1Image = new PImage[8];
PImage[] player2Image = new PImage[8];

void imageImporter(){
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
  
}//End imageImporter()

