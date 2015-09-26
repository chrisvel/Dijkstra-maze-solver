require_relative "solver.rb"

def header
  system('clear')
  puts "~" * 50
  puts "MazeSolver"
  puts "~" * 50
end

case ARGV[0]
when nil
  puts header
  puts "ERROR: You didn't choose a file with data!"
  puts
else
  case File.exist?(ARGV[0])
  when true
    solve_my_maze = MazeSolver.new(ARGV[0])
    result = solve_my_maze.solve_dijkstra

    case ARGV[1]
    when "ptr"
      puts header
      # print the table and the 1d numbers generated
      puts result.inspect

    when "pst"
      puts header
      # print final stats
      solve_my_maze.print_stats

    when "pnf"
      puts header
      # print the final node set with distances and previous nodes
      solve_my_maze.print_nodes_final

    when "ptr"
      puts header
      # print the table and the 1d numbers generated
      solve_my_maze.print_table_reverse

    when "out"
      # returns the result of the solution in array format (almost same as previous)
      puts result.inspect

    else
      puts "ERROR: Wrong arguments"
      puts
    end
  else
    puts "ERROR: File #{ARGV[0]} does not exist."
    puts
  end
end
