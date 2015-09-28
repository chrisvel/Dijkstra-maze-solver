##2d matrix maze solver

 The story:

 The program parses the maze as a string when the object is initialized and
 saves it in an array. The nodes are saved in series, so we need to reverse
 the table in order to use the matrix as a table [x,y].

 For the calculations to be easier, the reversed table's nodes are merged and
 then given an incremental number: [0,0] becomes 1, [1,0] becomes 8 etc.

 We are marking the nodes which are not walls (X) and save the start node (S).
 We've been said that the Goal node's location is unknown, so we leave it for
 the robot to discover. Then we save each node's neighbours in a hash, after
 checking that none of them is outside of the edges of the matrix.

 Then we iterate over the node list, picking up the neighbour node with the
 smallest distance value and move on. In order to keep track of what we' ve
 discovered and what' s left to be done, we keep an unvisited nodes list and a
 queue (LIFO).

 If we find a node with a "G" as a value then we' ve reached our goal, so we
 backtrack our solution, following the previous nodes inside of each hash/node
 and then return the final array.

 Dijkstra 's algorithm is being used in order to solve the maze puzzle.

 Web references that have been used for the solution:
 * https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
 * Various youtube lecture videos on Dijkstra's algorithm
 * https://www.relishapp.com/rspec/rspec-expectations/v/3-3
 * https://gist.github.com/adamstegman/926858 # to silence the stdout and redirect to /dev/null

###Usage

The execution of the program is pretty simple and uses optparser:

`ruby main.rb data/maze.txt [argument]`

Where `[argument]` can be:
 * `pst`: prints final statistics for the maze and the solution
 * `pnf`: prints the final node set with distances and previous nodes
 * `ptr`: print the table and the 1d numbers generated
 * `out`: returns the result table

The result table can also be redirected to a file:

`ruby main.rb data/maze.txt out > output.txt`

in array format:

`[[2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [6, 8], [6, 9]]`

Simple error checking is made when the file does not exist or the arguments are wrong and the appropriate error is printed on the console.
