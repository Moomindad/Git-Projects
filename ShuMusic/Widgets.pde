// ###################################################################
// STANDARD WIDGETS
// ###################################################################
// In this file all the widgets used in the program, i.e., buttons,
// checkboxes, etc.
//
interface Widget {
  void handleClick(float mx, float my);
  void checkKey(char pressedKey);
}

// ###################################################################
// Standard button. This button reacts to hovering, clicking and also
// defines the keystroke for the action.
//
class Button implements Widget {
  float x, y, w, h;
  String label;
  boolean isDefault;
  boolean hover = false;
  char hotkey;
  Action action;

  // Constructor
  //
  Button(float x, float y, float w, float h, String label, boolean isDefault, char hotkey, Action act) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.isDefault = isDefault;
    this.hotkey = hotkey;
    this.action = act;
  }

  void setAction(Action act) {
    this.action = act;
  }

  // The function  called in every loop in the draw function.
  //
  void display() {
    hover = (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
    stroke(0);
    fill(hover ? color(180, 220, 255) : (isDefault ? color(100, 150, 255) : 200));
    rect(x, y, w, h, 8);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }
  // ###################################################################
  // The interaction definitions for this application. Mouse clicks, key
  // strokes, etc. have to be overridden here.
  // ###################################################################
  // A single button click is defined here. No error checks are made!
  //
  void handleClick(float mx, float my) {
    if (mx > x && mx < x+w && my > y && my < y+h) {
      this.action.execute(mouseX, mouseY);
    }
  }

  // ###################################################################
  // We need to be able to do things different ways. Control-keys are
  // one such way.
  //
  void checkKey(char pressedKey) {
    if (Character.toUpperCase(pressedKey) == Character.toUpperCase(hotkey)) {
      this.action.execute(mouseX, mouseY);
    }
  }
}
// ###################################################################
// POPUP MENUS
// ###################################################################
// A popup menu is very useful for dynamic lists. We can add data continuously, and
// have the list altered accordingly. The selections are referred to throught Strings.
//
class PopupMenu {
  float x, y, w;
  String[] items;
  int selectedIndex = 0;
  boolean expanded = false;

  PopupMenu(float x, float y, float w, String[] items) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.items = items;
  }

  void display() {
    fill(255);
    if (mouseOver()) fill(220);
    stroke(0);
    rect(x, y, w, 25, 6);
    fill(0);
    textAlign(LEFT, CENTER);
    text(items[selectedIndex], x + 5, y + 13);
    triangle(x+w-15, y+10, x+w-5, y+10, x+w-10, y+17);

    if (this.expanded) {
      for (int i = 1; i < items.length; i++) {
        fill(255);
        if (mouseX > x && mouseX < x+w && mouseY > y+25*i && mouseY < y+25*(i+1)) fill(220);
        stroke(0);
        rect(x, y + 25*i, w, 25, 6);
        fill(0);
        text(items[i], x + 5, y + 25*i + 13);
      }
    }
  }

  // The height of the collapsed or the expanded menu has to be calculated in each
  // loop.
  //
  float getHeight() {
    return expanded ? 25 * items.length : 25;
  }

  // The call to mouseOver() is not driven by the mouse, but by the continuous
  // polling of the mouse positions.
  //
  boolean mouseOver() {
    return mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+25;
  }

  void toggle(float mx, float my) {
    if (mouseOver()) {

      this.expanded = !this.expanded;
    } else if (this.expanded) {
      for (int i = 1; i < items.length; i++) {
        if (mx > x && mx < x+w && my > y + 25*i && my < y + 25*(i+1)) {
          selectedIndex = i;
          println("Popup selected: " + items[i]);
        }
      }
      expanded = false;
    }
  }
}

// ###################################################################
// KNOB
// ###################################################################
//
// This is an example on how it is possible to create a rotary knob.
// Knobs are not always easy controls for the user, in that they are
// most often (as here as well) not handled with any rotary motion, but
// rather with a sliding motion (even though the knob rotates visually).
//
class Knob implements Widget {
  float x, y, radius, min, max, clicks;
  int petals;            // The "petals" are the ridges of the knob.
  float angle = 0;
  boolean dragging = false;
  float lastMouseAngle;
  String label
    ;

  // Constructor. We can set the number of ridges on the knob.
  //
  Knob(float x, float y, float radius, int petals, String label, int min, int max, int click) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.petals = petals;

    this.label = label;
    this.min = min;
    this.max = max;
    this.clicks = click;
  }

  // To draw the knob we save the previous state of the graphics.
  //
  void display() {

    // First draw the rotation of the knob
    //
    pushMatrix();
    translate(x, y);
    rotate(angle);

    drawPetals();
    drawCenter();
    popMatrix();
    drawLabel();
  }

  void drawLabel() {
    // Display the value underneath the knob.
    //
    push();
    fill(255);
    textAlign(CENTER);

    // The value is the rotation angle in proportion to the difference between
    // the max and the minimum value.
    //
    float diff = this.max - this.min;
    float val = this.min + diff;
    float mul = this.angle / PI;
    float fvalue = abs(val * mul);
    int value = (int) fvalue / 2;
    text(this.label +  value, x, y + radius + 35);
    pop();
  }

  void drawCenter() {
    // Draw the centre of the knob. It is featureless, so it
    // doesn't really have to rotate.
    //
    fill(100);
    ellipse(0, 0, radius * 1.25, radius * 1.25);
  }

  void drawPetals() {
    fill(180, 220, 250);

    // No borders on the petals.
    //
    noStroke();

    for (int i = 0; i < petals; i++) {
      float a = TWO_PI / petals * i;

      // Polar coordinates are used for the drawing of the ridges
      // around the knob.
      //
      float px = cos(a) * radius;
      float py = sin(a) * radius;

      // It would be good if it were possible to have smaller circles
      // for the ridges. Exercise!
      //
      ellipse(px, py, radius / 3, radius / 3);
    }
  }

  // If the mouse is pressed, the knob is "activated" and subsequent
  // dragging will change the value.
  //
  void handleClick(float mx, float my) {
    if (dist(mx, my, x, y) < radius * 1.5) {
      dragging = true;
      lastMouseAngle = atan2(my - y, mx - x);
    }
  }

  // Dragging the mouse will only work during the same mousepress. Once
  // it is released, the knob will be deactivated.
  //
  void handleDrag(float mx, float my) {

    if (dragging) {
      float newAngle = atan2(my - y, mx - x);
      float delta = newAngle - lastMouseAngle;
      angle += delta;
      lastMouseAngle = newAngle;
      println("Angle: ", newAngle);
    }
  }


  // Once we release the mouse button the dragging is finished, and
  // knob will be deactivated again.
  //
  void handleRelease() {
    dragging = false;
  }

  // Interface requirement.
  //
  void checkKey(char k) {
  }
}

// ###################################################################
// RESTRICTED KNOB
// ###################################################################
//

// Restricted knob.
//
class RestrictedKnob extends Knob {

  // Angles of movement.
  //
  int start;
  int end;
  RestrictedKnob(float x, float y, float radius, int petals, String label, int min, int max, int click, int start, int end) {
    super(x, y, radius, petals, label, min, max, click);
    this.start = start;
    this.end = end;
  }

  void drawPetals() {
  }

  // Overriding the knob display.
  //
  void display() {
    super.display();
  }
}

// ###################################################################
// SLIDER
// ###################################################################
// The slider is almost the same thing as a knob, but the
// dragging is constrained in one direction. Sliders are in
// some way more intuitive than the knobs, and should be the
// preferred choice in the interface.
//
class Slider implements Widget {
  float x, y, w;
  float minVal, maxVal, startVal;
  float value;
  boolean dragging = false;
  String label; 

  // Constructor.
  //
  Slider(float x, float y, float w, String label, float minVal, float maxVal, float startVal) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.minVal = minVal;
    this.maxVal = maxVal;
    this.value = startVal;
    this.label = label;
  }

  // The presentation of the slider is quite straightforward. We draw a
  // narrow rectangle with rounded corners as the slide, and a circle
  // becomes the slideknob. We could of course use a rectangle instead.
  //
  void display() {
    stroke(0);
    fill(220);
    rect(x, y, w, 6, 4);

    // The slideknob position has to be calculated from the current
    // position value since it is redrawn all the time.
    //
    float pos = map(value, minVal, maxVal, 0, w);
    fill(100);
    ellipse(x + pos, y + 3, 16, 16);

    fill(255);
    textAlign(LEFT);
    text(floor(minVal), x, y - 10);
    textAlign(RIGHT);
    text(floor(maxVal), x + w, y - 10);
    textAlign(CENTER);
    text("Value: " + floor(value),  x + w / 2, y + 25);
  }

  // If the mouse is pressed, the slider is "activated" and subsequent
  // dragging will change the value.
  //
  void handleClick(float mx, float my) {
    if (mx > x && mx < x + w && abs(my - y) < 15) {
      dragging = true;
      update(mx);
    }
  }

  // Dragging the mouse will only work during the same mousepress. Once
  // it is released, the slider will be deactivated.
  //
  void handleDrag(float mx, float my) {
    if (dragging) {
      update(mx);
    }
  }

  // Once we release the mouse button the dragging is finished, and
  // knob will be deactivated again.
  //
  void handleRelease() {
    dragging = false;
  }

  // Interface requirement.
  //
  void checkKey(char k) {
  }


  void update(float mx) {
    float pos = constrain(mx, x, x + w);
    value = map(pos, x, x + w, minVal, maxVal);
  }
}
// ###################################################################
// END OF WIDGETS
// ###################################################################
