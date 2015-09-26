# print statistics to the console
class MazePrint

  def initialize(options={})
    @table_merged = options[:table_merged]
    @nodes = options[:nodes]
    @table_x = options[:table_x]
    @start_node = options[:start_node]
    @goal_node = options[:goal_node]
    @backtrack = options[:backtrack]
    @shortest_path = options[:shortest_path]
    @node_list = options[:node_list]
    @data = options[:data]
  end

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
