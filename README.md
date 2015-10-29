# Reverse Polish Notation of Spreadsheet

### Usage
Given a csv file with RPNs,  
- Run ```./rpn.rb -f <csv file>``` to see default output file ```rpn.csv```
- ```-o``` can be use to specify an output file
- Usage```./rpn.rb --help``` 

### Solutions 
- Since it involves ```RPN```, the 1st impression is that it needs some ```Stack```. 
- Since there are multiple RPN and could have references inside RPN, it will need ```Hash``` for looking up other cells. And it might need ```recuisive function call``` when there is a reference.
- It is possible that there are some cyclical refernce, which will need a ```HashSet``` to help remember whether a cell has been referred twice

### Design
1. using a Hash to store all the cell/notations. (key: csv column + row, value: rpn)
2. enumate the hash until every RPNs are evaluated
3. use an auxiliary stack to evaluate individual RPN
4. when there is a reference, make a recursive function all if the reference cell is another rpn, otherwise fetch the cell value
5. once a RPN is evaluated, update its value in the hash

#### Ruby implementations
1. In Rudy the array of array can have varied size of array. So ```Hash``` is not used.
2. In Ruby the ```Array``` can be used as a ```Stack```.
3. Using Ruby's ```Hash``` as the ```HashSet``` to help detect cyclical reference.


### Assumptions
1. if the reference cell is a valid CSV cell, but it does not exist in the csv file. In this case, assume the value is '#ERR'
   for example, if the csv file only 1 row, but the reference cell is in the 2nd row. the value of that RPN will be '#ERR'
2. if divisor is zero, the value of RPN will be '#ERR'
3. Cyclicial reference will result in '#ERR' for those cells

### Limitations
1. Data structures used
   - When processing RPN of each cell, there is an unnecessary Array copy as Ruby's dup/clone will keep the same reference with orignal array object.

### Test
1. Ruby rspec with 100% coverage with command ```rake rubocop```
2. Test under ruby 2.2.0 with command ```rspec```


