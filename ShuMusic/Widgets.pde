// ###################################################################
// STANDARD WIDGETS
// ###################################################################
// In this file all the widgets used in the program, i.e., buttons,
// checkboxes, etc.
//
// ###################################################################
// Standard button. This button reacts to hovering, clicking and also
// defines the keystroke for the action.
//
class Button {
  float x, y, w, h;
  String label;
  boolean isDefault;
  boolean hover = false;
  char hotkey;
  Action action;

  // Constructor
  //
  Button(float x, float y, float w, float h, String label, boolean isDefault, char hotkey) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.isDefault = isDefault;
    this.hotkey = hotkey;
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
      this.action.execute();
    }
  }

  // ###################################################################
  // We need to be able to do things different ways. Control-keys are
  // one such way.
  //
  void checkKey(char keyPressed) {
    if (Character.toUpperCase(keyPressed) == Character.toUpperCase(hotkey)) {
      this.action.execute();
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
// END OF WIDGETS
// ###################################################################
