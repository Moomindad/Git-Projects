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
