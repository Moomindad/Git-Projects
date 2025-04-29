// ###################################################################
// This file contains all the actions needed for the widgets and 
// gadgets. Each action consists of an object with a set of methods 
// defining the action. The actions make use of the Command pattern, and 
// implement the interface Action.
// ###################################################################
// The interface Action
// 
interface Action {
  
  void execute();
  void unexecute();
  void reexecute();
  
}

class ActionList extends

// ###################################################################
// Each action that will be performed in the system will have to be 
// implemented as a separate class, but implementing the interface.
// These functions need to be called when a widget is used.
// ###################################################################
// 
// Selecting a new set of patterns. 
// 
class patternSelect implements Action {
  
  void execute(){};
  void unexecute(){};
  void reexecute(){};
  
}

// ###################################################################
// END ACTIONS
// ###################################################################
