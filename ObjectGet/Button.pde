//Button objects create a square on the screen which you can press to do various things.
class Button {
  int x;
  int y;
  int height;
  int width;
  color shade; //the color of the button
  String label; //a label which will be put in the bottom left corner of the button.

  boolean active; //Allows you to turn the button on and off
  boolean side; //left = true, right = false

  Button(int x, int y, int width, int height, String label, boolean side)
  {
    this.x = x;
    this.y = y;
    this.height = height;
    this.width = width;
    shade = color(30, 30, 30);
    active = true;
    this.label = label;
    this.side = side;
    
  }

  Button(int x, int y, int height, int width, color shade, String label, boolean side)
  {
    this.x = x;
    this.y = y;
    this.height = height;
    this.width = width;
    this.shade = shade;
    this.label = label;
    active = true;
    this.side = side;
  }

  Button(int x, int y, int height, int width, int r, int g, int b, String label, boolean side)
  {
    this.x = x;
    this.y = y;
    this.height = height;
    this.width = width;
    shade = color(r, g, b);
    active = true;
    this.label = label;
    this.side = side;
  }

  //draws the button on the screen
  void display()
  {
    fill(shade);
    rect(x, y, width, height);
    fill(0);
    if(side){
      text(label, x + 10, y + height - 10);
    }
    else{
      text(label, x + width - 30, y + height -10);
    }
  }

  //is (x,y) inside the button?
  public boolean isWithin(int inputX, int inputY)
  {
    if (inputX >= x && inputX <= (x+width) && inputY >= y && inputY <= (y+height) && active)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  public void changeColor(int r, int g, int b)
  {
    shade = color(r, g, b);
  }

  public void on()
  {
    active = true;
  }

  public void off()
  {
    active = false;
  }
  
  public color getColor(){
    return shade;
  }
}
