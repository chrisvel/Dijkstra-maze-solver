##
# 2d matrix maze solver
#
# The story:
# The program parses the maze as a string when the object is initialized and
# saves it in an array. The nodes are saved in series, so we need to reverse
# the table in order to use the matrix as a table [x,y].
#
# For the calculations to be easier, the reversed table's nodes are merged and
# then given an incremental number: [0,0] becomes 1, [1,0] becomes 8 etc.
#
# We are marking the nodes which are not walls (X) and save the start node (S).
# We've been said that the Goal node's location is unknown, so we leave it for
# the robot to discover. Then we save each node's neighbours in a hash, after
# checking that none of them is outside of the edges of the matrix.
#
# Then we iterate over the node list, picking up the neighbour node with the
# smallest distance value and move on. In order to keep track of what we' ve
# discovered and what' s left to be done, we keep an unvisited nodes list and a
# queue (LIFO).
#
# If we find a node with a "G" as a value then we' ve reached our goal, so we
# backtrack our solution, following the previous nodes inside of each hash/node
# and then return the final array.
#
# Dijkstra 's algorithm is being used in order to solve the maze puzzle.
#
# Web references that have been used for the solution:
# * https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
# * Various youtube lecture videos on Dijkstra's algorithm
#
##
class MazeSolver

  attr_reader :table_merged, :table_x, :start_node, :goal_node, :shortest_path, :backtrack, :node_list
  attr_accessor :data, :nodes, :table

  def initialize(data, nodes, table, table_reversed)
    @data = data
    @nodes = nodes
    @table = table
    @table_reversed = table_reversed
    @table_merged = []
    @table_convert = []
    @step = 1
    @start_node = 999
    @goal_node =  999
    @current_node = 999
    @table_x = 0
    @table_y = 0
    @unvisited_set = []
    @node_list = []
    @shortest_path = []
    @shortest_path_coords = []
    @backtrack = []
    parse_maze
    create_unvisited_set
    set_table_size
    create_nodes
  end

  # convert the maze string to an array of arrays
  def parse_maze

    # search for start node but not for the goal node
    # the robot does not know where the goal node is but we need to find out
    # where to start at
    x = 0
    y = 0
    z = 0 # will be used as a node number
    @table_reversed.each do |row|
      row.each do |item|
        @start_node = z if item == "S"

        # create a simple array with all values
        @table_merged << item
        @table_convert << [item, [x, y]]
        y = y + 1
        z = z + 1
      end
      x = x + 1
      y = 0
    end
  end # parse_maze

  # create the unvisited set of nodes but remove walls
  def create_unvisited_set
    @unvisited_set = @nodes.map { |r| r if @table_merged[r] != "X" }
    @unvisited_set.delete(nil)
  end

  # set table size values
  def set_table_size
    @table_x = @table_reversed[0].size
    @table_y = @table_reversed.size
  end

  # initialize nodes structure
  def create_nodes

    previous_node = nil

    # set the current node as the start one
    @current_node = @start_node

    # create a copy of the instance set
    unvisited_set = @unvisited_set.dup

    # iterate until there are no unvisited nodes
    while unvisited_set.size > 0 do

      # set the current node as the first element of the list and remove it
      @current_node = unvisited_set.shift

      # set values for neighbours
      neighbours = []
      left_node = @current_node - @step
      top_node = @current_node + @table_x
      right_node = @current_node + @step
      bottom_node = @current_node - @table_x

      # check If neighbours are not in the edges
      if left_node > 0 && @current_node % @table_x != 0 && @table_merged[left_node] != "X"
        neighbours << left_node
      end
      if top_node < (@table_x * @table_y) && @table_merged[top_node] != "X"
        neighbours << top_node
      end
      if bottom_node - @table_x >= 0 && @table_merged[bottom_node] != "X"
        neighbours << bottom_node
      end
      if (@current_node + @step) % @table_x != 0 && @table_merged[right_node] != "X"
        neighbours << right_node
      end

      # check If the current node is the goal node
      @goal_node = @current_node if @table_merged[@current_node] == "G"

      # We should assign to every node a tentative distance value: set it to
      # zero for our initial node and to Float::INFINITY for all other nodes.
      # In our case we know that there is a standard distance between
      # neighbours (1).
      @current_node == @start_node ? @distance = 0 : @distance = @step

      # Create a Hash for current node and append each node to a table.
      # For the current node, consider all of its unvisited neighbors and
      # calculate their tentative distances. In the current solver
      # all distances of the neighbour nodes are 1.
      @node_list << {
        id: @current_node,
        neighs: neighbours,
        dist: @distance,
        prev: previous_node
      }
    end

    return @node_list
  end # create nodes

  # does what it says !
  def solve_dijkstra

    unvisited_set = @unvisited_set.dup

    # create a queue for nodes to check
    @queue = []
    current_node = @start_node
    @queue << current_node

    # Stop If there are no unvisited nodes or the queue is empty
    while unvisited_set.size > 0 && @queue.size > 0 do

      # set the current node as visited and remove it from the unvisited set
      current_node = @queue.shift

      # remove visited node from the list of unvisited nodes
      unvisited_set.delete(current_node)

      # find the current node's neighbours and add them to the queue
      rolling_node = @node_list.find { |hash| hash[:id] == current_node }
      rolling_node[:neighs].each do |p|
        # only add them if they are unvisited and they are not in the queue
        if unvisited_set.index(p) && !@queue.include?(p)
          @queue << p
          # set the previous node as the current for its neighbours
          change_node = @node_list.find { |hash| hash[:id] == p }
          change_node[:prev] = current_node
          # increase the distance of each node visited
          change_node[:dist] = rolling_node[:dist] + @step
        end
      end

      if current_node == @goal_node
        find_shortest_path(rolling_node)
        break
      end
    end
    return @shortest_path_coords
  end # solve_dijkstra

  # Retrieves the shortest path by backtracking
  def find_shortest_path(rolling_node)

    @backtrack = []
    @backtrack << @goal_node

    # iterate until we arrive at the start node
    while rolling_node[:prev] != nil do
      temp_node = @node_list.find { |hash| hash[:id] == rolling_node[:prev] }
      @backtrack << temp_node[:id]
      rolling_node = temp_node
    end

    # create a table with the 1d and the 2d array node values
    @shortest_path = []

    @backtrack.each do |p|
      @shortest_path << [p, @table_convert[p]]
      @shortest_path_coords << @table_convert[p][1]
    end
  end

end
