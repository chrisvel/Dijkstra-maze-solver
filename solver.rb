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

require 'json'

class MazeSolver

  def initialize(file)
    @file = file
    @data = ""
    @table = Array.new
    @table_reversed = Array.new
    @table_merged = Array.new
    @table_convert = Array.new
    @nodes = Array.new
    @step = 1
    @start_node = 999
    @goal_node =  999
    @current_node = 999
    @table_x = 0
    @table_y = 0
    @unvisited_set = Array.new
    @node_list = Array.new
    @shortest_path = Array.new
    @shortest_path_coords = Array.new
    @backtrack = Array.new
    parse_maze
    create_nodes
  end

  # convert the maze string to an array of arrays
  def parse_maze

    k = 0
    @data = File.read(@file)
    @data.strip.split(/[\l|\n\/]/).each do |line|
      @row = Array.new
      line.split(/ /).each do |item|
        @row << item
        # append an incremental number for each node, for example
        # [0,0] becomes 0, [0,1] becomes 1, [0,2] becomes 2 etc.
        @nodes << k
        k = k + 1
      end
      @table << @row
    end

    # flip table values horizontally
    @table_reversed = @table.reverse

    # search for start node but not for the goal node
    # the robot does not know where the goal node is but we need to find out
    # where to start at
    x = 0
    y = 0
    z = 0 # will be used as a node number
    @table_reversed.each do |row|
      row.each do |item|
        k = @nodes[z]
        @start_node = z if item == "S"

        # create a simple array with all values
        @table_merged << item
        @table_convert << [item, [x,y]]
        y = y + 1
        z = z + 1
      end
      x = x + 1
      y = 0
    end

    # set table size values
    @table_x = @table_reversed[0].size
    @table_y = @table_reversed.size

    # create the unvisited set of nodes but remove walls
    @unvisited_set = @nodes.map { |r| r if @table_merged[r] != "X" }
    @unvisited_set.delete(nil)

    return @table_reversed
  end # parse_maze

  # initialize nodes structure
  def create_nodes

    nodes = Array.new
    previous_node = nil

    # set the current node as the start one
    @current_node = @start_node
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
        :id => @current_node,
        :neighs => neighbours,
        :dist => @distance,
        :prev => previous_node
      }
    end

    return @node_list
  end # create nodes

  # does what it says !
  def solve_dijkstra

    unvisited_set = @unvisited_set.dup

    # create a queue for nodes to check
    @queue = Array.new
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

        # go backwards to retrieve the shortest path
        @backtrack = Array.new
        @backtrack << current_node

        # iterate until we arrive at the start node
        while rolling_node[:prev] != nil do
          temp_node = @node_list.find { |hash| hash[:id] == rolling_node[:prev] }
          @backtrack << temp_node[:id]
          rolling_node = temp_node
        end

        # create a table with the 1d and the 2d array node values
        @shortest_path = Array.new
        count = 0

        @backtrack.each do |p|
          @shortest_path << [p, @table_convert[p]]
          @shortest_path_coords << @table_convert[p][1]
        end

        # break the loop
        return @shortest_path_coords
        break
      end
    end
  end # solve_dijkstra

  # prints the reversed table
  def print_table_reverse
    z = 0 # will be used as a node number
    @table_merged.each do |item|
      node = @nodes[z]
      print "#{item} (#{node}) \t"
      z = z + 1
      puts if z % @table_x == 0
    end
  end # print_table_reverse

  # prints stats.. what else ?
  def print_stats
    puts @data
    puts "~" * 50
    puts "Start node: #{@start_node}"
    puts "Goal node: #{@goal_node}"
    puts "Backtrack: #{@backtrack.inspect}"
    puts "Shortest Path: "
    @shortest_path.each do |p|
      puts "#{p[0]} \t #{p[1]}"
    end
    puts "~" * 50
    puts
  end # print_stats

  def print_nodes_final
    puts
    puts @node_list
    puts
  end

end
