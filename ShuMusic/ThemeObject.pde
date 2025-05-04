// ###################################################################
// Application theme 
// ###################################################################
// This is an attempt to create a style sheet for the interface design. 
// All settings that are to be seen as default for the design are defined 
// here, so that the colouring will be consistent throughout the application.
// 
// It is suggested that this will be used together with a push() and pop() 
// to make the theme working smoothly.
// 
class Theme {
  
  // Line colour
  // 
  color strokeColor = color(0, 0, 0);
  
  
  // Colour of background
  //
  color bgColor = color (220, 220, 100);
 
  // Fill color
  // 
  color fillColour = color(220, 220, 220);
  
  // Button colors. 
  // 
  color bColor =  color(200, 200, 200);
  color bHColor = color(180, 220, 255);
  color bDColor = color(100, 150, 255);
  
  // Other default values. 
  //
  int strWidth = 2;

  // CONSTRUCTOR
  //
  Theme() {
    
  }
   
}
// 
