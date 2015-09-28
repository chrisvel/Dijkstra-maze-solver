#!/usr/bin/env ruby

require_relative "lib/mazefile.rb"
require_relative "lib/mazesolver.rb"
require_relative "lib/mazeprint.rb"
require 'optparse'

options = {}

option_parser = OptionParser.new do |opt|
  opt.banner = "
    MazeSolver v1.0.1 - Solves mazes with walls...
    Usage: main.rb -f <filename> [OPTION]

    Options
    "
  opt.on("-f", "choose the path and the filename of the maze") do
    options[:file] = true
  end
  opt.on("--ptb", "prints the table and the 1d numbers generated") do
    options[:ptb] = true
  end
  opt.on("--pst", "prints statistics") do
    options[:pst] = true
  end
  opt.on("--pnf", "prints the final node set with distances and previous nodes") do
    options[:pnf] = true
  end
  opt.on("--ptr", "prints the table and the 1d numbers generated") do
    options[:ptr] = true
  end
  opt.on("-o", "--out", "returns the result of the solution in array format (almost same as previous)") do
    options[:out] = true
  end
  opt.separator ''
end

begin
  option_parser.parse!
  rescue OptionParser::InvalidOption => error
  puts "Cannot recognize #{ error }"
  exit
  rescue OptionParser::AmbiguousOption => error
  puts "That's an #{ error}"
  exit
end

if options[:file]
  begin
    maze_file = MazeFile.new(ARGV[0])

    solve_my_maze = MazeSolver.new(maze_file.data, maze_file.table, maze_file.table_reversed)
    result = solve_my_maze.solve_dijkstra

    args = [
      table_merged: solve_my_maze.table_merged,
      nodes: solve_my_maze.nodes,
      table_x: solve_my_maze.table_x,
      start_node: solve_my_maze.start_node,
      goal_node: solve_my_maze.goal_node,
      backtrack: solve_my_maze.backtrack,
      shortest_path: solve_my_maze.shortest_path,
      node_list: solve_my_maze.node_list,
      data: solve_my_maze.data
    ]
    print_maze_stats = MazePrint.new(*args)

    if options[:ptb]
      # print the table and the 1d numbers generated
      puts result.inspect
    elsif options[:pst]
      # print final stats
      print_maze_stats.print_stats
    elsif options[:pnf]
      # print the final node set with distances and previous nodes
      print_maze_stats.print_nodes_final
    elsif options[:ptr]
      # print the table and the 1d numbers generated
      print_maze_stats.print_table_reverse
    elsif options[:out]
      # returns the result of the solution in array format (almost same as previous)
      puts result.inspect
    end
    rescue TypeError, ArgumentError
      puts "ERROR: You didn't set a file name"
    rescue Errno::ENOENT
      puts "ERROR: File \"#{ARGV[0]}\" does not exist"
      puts
  end
end
