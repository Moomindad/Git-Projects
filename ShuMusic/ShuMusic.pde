// ###################################################################
// The midibus library needs to be the one connected to this
// project, otherwise the MIDI connection will not work.
//
// ###################################################################
// IMPORTS
//
import themidibus.*;
import java.util.*;

// CONSTANTS
//
int maxPitch = 48;
int minPitch = 32;
int octave = 3;    // Default octave.

// ###################################################################
// VARIABLES
// ###################################################################
// MIDIbus is used to connect the program to a synthesizer.
//
MidiBus myBus;

GUI gui;

Theme at;

// Chordrelated Variables
//
ArrayList<ChordProgression> progressionList = new ArrayList<ChordProgression>();
ChordProgression currentProgression;
int currentProgIndex = 0;
int chordIndex = 0;
int noteIndex = 0;
int t = 0;
int interval = 1000;
int[] chord;
int[] rightMelody;
int rightNoteIndex = 0;
boolean rightPlaying = false;
int rightHandInterval = 1500;

int selectedModeIndex = -1; // set random selection of patterns as default
String[] modePatternLabels;
boolean randomMode = true;
boolean loopSelectedMode = false; // do not loop now

ArrayList<Integer> activeNotes = new ArrayList<Integer>();

// Pattern related global variables.
//
int[][] patterns;
int[] majorScale;
int[][] modePatterns;
int[] currentPattern;

// A pattern reader for the json-files.
//
ReadPattern rp;

// Example of how the patterns are stored.
//
//int[][] patterns = {
//  {0, 7, 12, 7},
//  {0, 7, 16, 7, 16, 7, 16, 7},
//  {0, 7, 12, 7, 16, 7, 12, 7},
//  {0, 7, 12, 14, 16},
//  {0, 7, 12, 14, 16, 19, 16, 14}
//};

//int[] currentPattern;
//int[] majorScale = {0, 2, 4, 5, 7, 9, 11};

//int[][] modePatterns = {
//  {1, 6, 4, 5},
//  {2, 5, 1},
//  {1, 4, 6, 5},
//  {3, 6, 2, 5},
//  {1, 3, 4, 2, 5}
//};


// ###################################################################
// Setting up the system
//
void setup() {

  // Control screen size.
  //
  size(800, 400);

  // Initiate the Midi communications. Note that the first number indicate the input
  // port, and the second number defines the output port.n
  //
  myBus = new MidiBus(this, -1, 6);

  at = new Theme();

  gui = new GUI();

  // TODO: create a function that initiates patterns:
  // initiatePatterns("patterns.json");
  //
  //=======================================
  // It is possible to create several instances of the pattern reader, each
  // handling one file.
  //
  rp = new ReadPattern("pattern1.json");


  patterns = rp.getPatterns();
  majorScale = rp.getMajorScale();
  modePatterns = rp.getModePatterns();
  //currentPattern = [];
  // =======================================
  // Generate a chord progression, between min and max pitch levels.
  //
  generateChordProgressions(32, 48, majorScale, modePatterns);
  currentProgression = progressionList.get(0);
  updateChord();

  modePatternLabels = new String[modePatterns.length];
  for (int i = 0; i < modePatterns.length; i++) {
    modePatternLabels[i] = "Pattern " + (i + 1);
  }
}

void draw() {
  background(50);
  fill(255);
  textSize(16);

  // Draw the GUI for the settings and workings.
  //
  gui.drawGUI();

  // Calculate the pace of playing. Current interval is based on then
  //
  int currentInterval = rightPlaying ? rightHandInterval : interval;

  if (millis() - t > currentInterval) {
    t = millis();

    turnOffActiveNotes();

    if (rightPlaying) {
      int note = rightMelody[rightNoteIndex];
      myBus.sendNoteOn(1, note, 100);
      activeNotes.add(note);
      rightNoteIndex++;

      if (rightNoteIndex >= rightMelody.length) {
        rightPlaying = false;
        noteIndex = 0;
        chordIndex++;
        if (chordIndex >= currentProgression.roots.length) {
          chordIndex = 0;
          if (!loopSelectedMode) {
            currentProgIndex = getNextProgressionIndex(currentProgIndex);
          }
          currentProgression = progressionList.get(currentProgIndex);
        }
        updateChord();
      }
    } else {
      int note = chord[noteIndex];
      myBus.sendNoteOn(0, note, 100);
      activeNotes.add(note);
      noteIndex++;

      if (noteIndex >= chord.length) {
        if (random(1) < 0.5) {
          generateRightMelody();
          if (rightMelody.length > 0) {
            rightPlaying = true;
            rightNoteIndex = 0;
            return;
          }
        }

        noteIndex = 0;
        chordIndex++;
        if (chordIndex >= currentProgression.roots.length) {
          chordIndex = 0;
          if (!loopSelectedMode) {
            currentProgIndex = getNextProgressionIndex(currentProgIndex);
          }
          currentProgression = progressionList.get(currentProgIndex);
        }
        updateChord();
      }
    }
  }
}


boolean isCompatible(int from, int to) {
  int diff = abs(from - to);
  return diff == 0 || diff == 5 || diff == 7 || diff <= 2;
}

void mousePressed() {

  // Check if any widget is clicked on.
  //
  gui.handleClick(mouseX, mouseY);

  //
  for (int i = 0; i < modePatternLabels.length; i++) {
    if (mouseX > 20 + i * 100 && mouseX < 20 + i * 100 + 90 &&
      mouseY > height - 40 && mouseY < height - 10) {
      selectedModeIndex = i;
      randomMode = false;
      loopSelectedMode = true;
      regenerateProgressions();
      // reset the index and loop
      currentProgIndex = 0;
      chordIndex = 0;
      currentProgression = progressionList.get(currentProgIndex);
      updateChord();
    }
  }

  // if click random pattern
  if (mouseX > width - 120 && mouseX < width - 20 &&
    mouseY > height - 40 && mouseY < height - 10) {
    randomMode = true;
    selectedModeIndex = -1;
    loopSelectedMode = false;
    
    regenerateProgressions();
    currentProgIndex = 0;
    chordIndex = 0;
    currentProgression = progressionList.get(currentProgIndex);
    updateChord();
  }
}


void mouseDragged() {
  
  gui.handleDrag(mouseX, mouseY);
}

void mouseReleased() {
  gui.handleRelease();
}
