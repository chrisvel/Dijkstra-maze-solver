#!/usr/bin/env ruby

require_relative "lib/mazesolver.rb"
require 'optparse'

options = {}

option_parser = OptionParser.new do |opt|
  opt.banner = "
    MazeSolver v1.0.1 - Solves mazes with walls...
    Usage: main.rb -f <filename> [OPTIONS]

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
  opt.separator ""
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
    solve_my_maze = MazeSolver.new(ARGV[0])
    result = solve_my_maze.solve_dijkstra
    if options[:ptb]
      # print the table and the 1d numbers generated
      puts result.inspect
    elsif options[:pst]
      # print final stats
      solve_my_maze.print_stats
    elsif options[:pnf]
      # print the final node set with distances and previous nodes
      solve_my_maze.print_nodes_final
    elsif options[:ptr]
      # print the table and the 1d numbers generated
      solve_my_maze.print_table_reverse
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
