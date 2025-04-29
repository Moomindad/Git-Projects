
class ReadPattern {

  // Deklaration of arrays
  //
  int[][] array2d_1;
  int[] array1d;
  int[][] array2d_2;

  String filePath = "Data/";

  // Constructor  // "pattern1.json"
  //
  ReadPattern(String file) {

    String fileName = this.filePath + file; // The pattern files are
    // the folder "Data"    JSONObject json = loadJSONObject(fileName);
    JSONObject json = loadJSONObject(fileName);

    // Läs in de två-dimensionella arrayerna
    //
    array2d_1 = parse2DIntArray(json.getJSONArray("array2d_1"));
    array2d_2 = parse2DIntArray(json.getJSONArray("array2d_2"));

    // Läs in den en-dimensionella arrayen
    //
    array1d = parse1DIntArray(json.getJSONArray("array1d"));

    // Skriv ut data för att kontrollera att de lästes in korrekt
    //
    println("array2d_1:");
    print2DArray(array2d_1);

    println("\narray1d:");
    print1DArray(array1d);

    println("\narray2d_2:");
    print2DArray(array2d_2);
  }

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

  // Funktion för att konvertera en JSONArray till en en-dimensionell int-array
  //
  int[] parse1DIntArray(JSONArray jsonArray) {
    int[] result = new int[jsonArray.size()];
    for (int i = 0; i < jsonArray.size(); i++) {
      result[i] = jsonArray.getInt(i);
    }
    return result;
  }

  int[][] getPatterns() {
    return this.array2d_1;
  }
  
  int[] getMajorScale() {
    return this.array1d;
  }
  
  int[][] getModePatterns() {
    return this.array2d_2;
  }
  
}

// Funktion för att skriva ut en två-dimensionell array
//
void print2DArray(int[][] arr) {
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[i].length; j++) {
      print(arr[i][j] + "\t");
    }
    println();
  }
}

// Funktion för att skriva ut en en-dimensionell array
//
void print1DArray(int[] arr) {
  for (int i = 0; i < arr.length; i++) {
    print(arr[i] + "\t");
  }
  println();
}
