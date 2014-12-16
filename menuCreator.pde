void startMenu(int l){
  background(0);
  textAlign(CENTER);
  textSize(15);
  fill(#00FF00);
  text("Press space to continue, or hit a number key to select an unlocked level", width/2, height/3);
  String availableLevels = "Unlocked level(s):";
  switch(l){
    case 1:
      availableLevels = availableLevels + " 1";
      break;
    case 2:
      availableLevels = availableLevels + " 1 and 2";
      break;
    default:
      //Do nothing
      break;
    //End switch(l)
  }
  text(availableLevels, width/2, height/3 + 20);
  
}//End startMenu
