// ###################################################################
// DATA BASE MANAGEMENT. 
// ###################################################################
// All patterns are stored in separate json files. See the file pattern1.json for
// an example.
//
class ReadPattern {

  // Deklaration of arrays that will be used in the program.
  // The pattern definitions are as follows:
  // - array2d_1 contains the main arpeggio patterns for a single chord.
  //
  // - array1d contains the current major chord.
  // - array2d_2 contains the different chord progressions that will be played.
  //
  int[][] array2d_1;
  int[] array1d;
  int[][] array2d_2;

  // All the pattern files are stored in the Data directory.
  //
  String filePath = "Data/";

  // Constructor
  //
  ReadPattern(String file) {

    String fileName = this.filePath + file; // The pattern files are
    // the folder "Data"
    JSONObject json = loadJSONObject(fileName);

    // First get the two-dimensional arrays.
    //
    array2d_1 = parse2DIntArray(json.getJSONArray("array2d_1"));
    array2d_2 = parse2DIntArray(json.getJSONArray("array2d_2"));

    // Then get the one-dimensional array.
    //
    array1d = parse1DIntArray(json.getJSONArray("array1d"));
  }

  // Print the note patterns.
  //
  void printPatterns() {

    // Get a printout of the arrays if needed to see the content.
    //
    println("array2d_1:");
    print2DArray(array2d_1);

    println("\narray1d:");
    print1DArray(array1d);

    println("\narray2d_2:");
    print2DArray(array2d_2);
  }


  // Convert the json arrays (JSONArray) to integer arrays (int[][]).
  // This is for the 2D arrays.
  // 
  int[][] parse2DIntArray(JSONArray jsonArray) {
    int rows = jsonArray.size();
    int[][] result = new int[rows][];

    for (int i = 0; i < rows; i++) {
      JSONArray row = jsonArray.getJSONArray(i);
      int cols = row.size();
      result[i] = new int[cols];

      for (int j = 0; j < cols; j++) {
        result[i][j] = row.getInt(j);
      }
    }
    return result;
  }
  
  
  // Convert the 1D json Array to a integer array. 
  // 
  int[] parse1DIntArray(JSONArray jsonArray) {
    int[] result = new int[jsonArray.size()];
    for (int i = 0; i < jsonArray.size(); i++) {
      result[i] = jsonArray.getInt(i);
    }
    return result;
  }
  
  // Accessors for the different patterns
  // 1. the arpeggiopatterns,
  //
  int[][] getPatterns() {
    return this.array2d_1;
  }

  // 2. the major scale,
  //
  int[] getMajorScale() {
    return this.array1d;
  }
  
  // 3. the chordProgression patterns.
  //
  int[][] getModePatterns() {
    return this.array2d_2;
  }
}
// ###################################################################
// END OF DATABASE MANAGEMENT
// ###################################################################
