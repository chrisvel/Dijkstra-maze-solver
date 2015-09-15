require_relative "solver.rb"

system('clear')
puts "~" * 50
puts "MazeSolver"
puts "~" * 50

if __FILE__ == $0
  case ARGV[0]
  when nil
    puts "ERROR: You didn't choose a file with data!"
    puts
  else
    case File.exist?(ARGV[0])
    when true
      solve_my_maze = MazeSolver.new(ARGV[0])
      result = solve_my_maze.solve_dijkstra

      case ARGV[1]
      when "ptr"
        # print the table and the 1d numbers generated
        puts result.inspect

      when "pst"
        # print final stats
        solve_my_maze.print_stats

      when "pnf"
        # print the final node set with distances and previous nodes
        solve_my_maze.print_nodes_final

      when "ptr"
        # print the table and the 1d numbers generated
        solve_my_maze.print_table_reverse
      else
        puts "ERROR: Wrong arguments"
        puts
      end
    else
      puts "ERROR: File does not exist."
      puts
    end
  end
end
