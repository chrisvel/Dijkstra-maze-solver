require_relative "solver.rb"

# the maze in the example
maze ="
0 0 0 0 0 G X 0
0 0 0 0 X X X 0
0 0 0 0 0 0 0 0
X X X X 0 0 0 0
0 0 0 X 0 0 0 0
S 0 0 0 0 0 0 0
"

# path needs to walk backwards, start not in edge
maze2 ="
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
G 0 0 0 0 0 0 0
X 0 X X X X X X
0 S 0 0 0 0 0 0
0 0 0 0 0 0 0 0
"

# path needs to go backwards, goal not in edge
maze3 ="
0 0 0 0 0 0 X 0 0 S
0 0 0 0 X X X 0 0 0
0 0 0 0 0 0 0 0 0 X
X 0 X X 0 0 0 0 0 X
X 0 0 X 0 0 0 G X 0
X 0 0 0 0 0 0 0 0 X
0 0 0 0 X X X X 0 0
"

# a large maze to solve
maze4 ="
0 0 0 0 0 0 X 0 0 G 0 0
0 0 0 0 X X X 0 0 0 0 0
0 0 0 0 0 0 0 0 0 X 0 0
X 0 X X 0 0 0 0 0 X 0 0
X 0 0 X 0 0 0 0 X 0 0 0
X 0 0 0 0 0 0 0 0 X 0 0
0 0 0 0 X X X X 0 0 0 0
X 0 0 0 0 0 0 0 0 X 0 0
0 0 0 0 X X X X 0 0 0 0
X 0 0 0 0 0 0 0 0 X 0 0
0 0 0 0 X X X X 0 0 0 0
X 0 0 0 0 0 0 0 0 X 0 0
0 0 0 0 X X X X S 0 0 0
"

# big but not enough!
maze6 ="
0 G 0 0 0 X X 0 0 0 0 0 0 0 0 0 X 0
0 0 0 0 X X X 0 0 0 X X 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 X 0 0 0 0 0 0 0 0
X 0 X X 0 0 0 0 0 X 0 0 0 0 0 0 0 0
X 0 0 X 0 0 0 0 X 0 0 0 0 0 0 0 0 0
X 0 0 0 0 0 0 0 0 X 0 0 0 0 0 0 0 0
0 0 0 0 X X X X 0 0 0 0 0 0 0 0 0 0
0 0 0 0 X X X 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 X X X X X X X 0 0
X 0 X X 0 0 0 0 0 X 0 0 0 0 0 0 0 0
X 0 0 X 0 0 0 0 X 0 X X X X 0 0 0 0
X 0 0 S 0 0 0 0 0 X 0 0 0 0 0 0 0 0
0 0 0 0 X X X X 0 0 X X X X X 0 X 0
"

system('clear')
puts "~" * 50
puts "MazeSolver"
puts "~" * 50
puts maze6
puts "~" * 50

solve_my_maze = MazeSolver.new(maze6).solve_dijkstra

# print the final array
# puts solve_my_maze.inspect

# print the final node set with distances and previous nodes
# solve_my_maze.print_node_list
