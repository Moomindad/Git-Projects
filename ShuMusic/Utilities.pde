// ###################################################################
// UTILITIES FILE
// ###################################################################
// In this file general utility functions are defined.
//
// ###################################################################
// Pretty printing a two-dimensional array.
//
void print2DArray(int[][] arr) {
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[i].length; j++) {
      print(arr[i][j] + "\t");
    }
    println();
  }
}


// Pretty printing a one-dimensional array.
//
void print1DArray(int[] arr) {
  for (int i = 0; i < arr.length; i++) {
    print(arr[i] + "\t");
  }
  println();
}

// ##################################################################
// A simple dictionary containing key value pairs. A dictionary
// should ideally be able to hold any type of object. However, this
// is very difficult due to the strong typing of java. Therefore the
// dictionary will be specified to only hold objects of the type "Action".
// ##################################################################
// 
class Dictionary {
  ArrayList dict;
  ArrayList keys;
  int counter = 0;

  // CONSTRUCTOR
  //
  // Note that the lookup function consists of two parallel lists, one
  // with the key and one with the Action, and they are joined by having 
  // the same index in the respective lists.
  // 
  Dictionary() {
    dict = new ArrayList<Action>();
    keys = new ArrayList<String>();
  }
  
  // Adding a key and an Action to the dictionary.
  //
  void addToDict(String item, Action act) {
    dict.add(act);
    keys.add(item);
  }

  // Retrieve the Action corresponding to a certain key. 
  //
  Action getAction(String item) {
    for (int i = 0; i < dict.length; i++) {
      if (keys.get(i) == item) {
        return dict.get(i);
      }
    }
    return null; 
  }
}

// ##################################################################
// END OF UTILITIES
// ##################################################################
