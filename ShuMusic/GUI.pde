// ###################################################################
// GUI DEFINITIONS
// ###################################################################
//
// This is redrawn in every iteration of the loop

class DrawGUI {
  
  // Constructor
  // 
  DrawGUI() {
    
    // 
    for (int i = 0; i < modePatternLabels.length; i++) {
      if (selectedModeIndex == i) {
        fill(0, 200, 100);
      } else {
        fill(100);
      }
      rect(20 + i * 100, height - 40, 90, 30);
      fill(255);
      textAlign(CENTER, CENTER);
      text(modePatternLabels[i], 20 + i * 100 + 45, height - 25);
    }

    fill(randomMode ? color(0, 200, 100) : 100);//change color into green if it was chosen
    rect(width - 120, height - 40, 100, 30);
    fill(255);
    text("Random", width - 70, height - 25);

    fill(255);
    text("Current Mode: " + (randomMode ? "Random" : "Pattern " + (selectedModeIndex + 1)), 80, 30);

    if (rightPlaying) {
      int currentNote = rightMelody[rightNoteIndex];
      text("Right hand playing number: " + currentNote, 20, 60);
      text("Right hand playing: " + midiNoteToName(currentNote), 20, 90);
    } else {
      int currentNote = chord[noteIndex];
      int rootNote = currentProgression.roots[chordIndex];
      text("Now Playing: Notenumber " + currentNote + " (Rootnumber: " + rootNote + ")", 160, 60);
      text("Now Playing: " + midiNoteToName(currentNote) + " (Root: " + midiNoteToName(rootNote) + ")", 90, 90);
    }
  }
}
