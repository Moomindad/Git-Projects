import themidibus.*;
import java.util.*;

MidiBus myBus;

class ChordProgression {
  int[] roots;
  ChordProgression(int[] roots) {
    this.roots = roots;
  }
  int getStart() {
    return roots[0];
  }
  int getEnd() {
    return roots[roots.length - 1];
  }
}

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

int selectedModeIndex = -1; // set random as default
String[] modePatternLabels;
boolean randomMode = true;
boolean loopSelectedMode = false; // do not loop now

ArrayList<Integer> activeNotes = new ArrayList<Integer>();

int[][] patterns;
int[] majorScale;
int[][] modePatterns;
int[] currentPattern;

ReadPattern rp; 

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

void setup() {
  
  size(800, 400);
  myBus = new MidiBus(this, -1, 6);
  
  
  // =======================================
  rp = new ReadPattern("pattern1.json");
  
  patterns = rp.getPatterns();
  majorScale = rp.getMajorScale();
  modePatterns = rp.getModePatterns();
  //currentPattern = [];
  // ======================================= 
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
  
  // draw interaction
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
void updateChord() {
  int root = currentProgression.roots[chordIndex];

  // root range and white key
  if (root < 32 || root > 48 || !isWhiteKey(root)) {
    root = getRandomWhiteKey(32, 48);
    currentProgression.roots[chordIndex] = root;
  }

  if (currentPattern == null || random(1) < 0.3) {
    currentPattern = patterns[(int)random(patterns.length)];
  }

  chord = new int[currentPattern.length];
  for (int i = 0; i < currentPattern.length; i++) {
    chord[i] = root + currentPattern[i];
  }

  noteIndex = 0;
}

void generateRightMelody() {
  if (chord.length < 3) {
    rightMelody = new int[0];
    return;
  }

  int noteCount = 3 + (int)random(3); // 3 to 5 notes
  if (noteCount > chord.length) noteCount = chord.length;

  rightMelody = new int[noteCount];
  for (int i = 0; i < noteCount; i++) {
    rightMelody[i] = chord[chord.length - noteCount + i] + 12; // key+12 for right hand
  }

  // 60%chance to press the first and the third note together (make it not that flat..
  if (random(1) < 0.99 && rightMelody.length >= 3) {
    int firstNote = rightMelody[0];
    int thirdNote = rightMelody[2];
    activeNotes.add(firstNote);
    activeNotes.add(thirdNote);
    myBus.sendNoteOn(1, firstNote, 60);
    myBus.sendNoteOn(1, thirdNote, 60);
  }

  // beat of right hand
  float r = random(1);
  if (r < 0.3) {
    rightHandInterval = interval;         
  } else  {
    rightHandInterval = interval / 2;     
  }
}



boolean isCompatible(int from, int to) {
  int diff = abs(from - to);
  return diff == 0 || diff == 5 || diff == 7 || diff <= 2;
}

int getNextProgressionIndex(int currentIndex) {
  int from = progressionList.get(currentIndex).getEnd();
  ArrayList<Integer> candidates = new ArrayList<Integer>();
  for (int i = 0; i < progressionList.size(); i++) {
    if (i == currentIndex) continue;
    int to = progressionList.get(i).getStart();
    if (isCompatible(from, to)) {
      candidates.add(i);
    }
  }
  if (candidates.size() > 0) {
    return candidates.get((int) random(candidates.size()));
  } else {
    return (currentIndex + 1) % progressionList.size();
  }
}

void generateChordProgressions(int minRoot, int maxRoot, int[] scale, int[][] modePatterns) {
  for (int root = minRoot; root <= maxRoot; root++) {
    if (!isWhiteKey(root) && random(1) > 0.05) continue; //95% chance is white key

    for (int[] pattern : modePatterns) {
      int[] chordRoots = new int[pattern.length];
      for (int j = 0; j < pattern.length; j++) { // get each root note(pitch) of this modepattern,and add it into chordRoots
        int degree = pattern[j] - 1;
        int pitch = root + scale[degree % 7] + 12 * (degree / 7);
        chordRoots[j] = pitch;
      }
      progressionList.add(new ChordProgression( chordRoots));
    }
  }
}
//if midinote equals any number below, then return true
boolean isWhiteKey(int midiNote) {
  int note = midiNote % 12;
  return note == 0 || note == 2 || note == 4 || note == 5 || note == 7 || note == 9 || note == 11;
}

int getRandomWhiteKey(int min, int max) {
  while (true) {
    int note = (int)random(min, max + 1); //get any random note from min to max, int here is to make sure it's integer
    if (isWhiteKey(note)) return note; 
  }
}

String midiNoteToName(int midiNote) {
  String[] noteNames = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  int note = midiNote % 12;
  int octave = (midiNote / 12) - 1;
  return noteNames[note] + octave;
}

void mousePressed() {
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

void regenerateProgressions() {
  progressionList.clear();// clear everything in progression list
  if (randomMode) {
    generateChordProgressions(32, 48, majorScale, modePatterns);
  } else {
    int[][] single = { modePatterns[selectedModeIndex] };
    generateChordProgressions(32, 48, majorScale, single);
  }
}

void turnOffActiveNotes() {
  for (int note : activeNotes) {
    myBus.sendNoteOff(0, note, 100);
    myBus.sendNoteOff(1, note, 100);
  }
  activeNotes.clear();
}
