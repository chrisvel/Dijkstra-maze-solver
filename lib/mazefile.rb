# parses data from text files
class MazeFile

  attr_reader :data, :nodes, :table, :table_reversed

  def initialize(file)
    @file = file
    @data = []
    @nodes = []
    @table = []
    @table_reversed = []
    read_file
    reverse_table
  end

  # reads data from the maze file to @table
  def read_file
    k = 0
    @data = File.read(@file)
    @data.strip.split(/[\l|\n\/]/).each do |line|
      @row = []
      line.split(/ /).each do |item|
        @row << item
        # append an incremental number for each node, for example
        # [0,0] becomes 0, [0,1] becomes 1, [0,2] becomes 2 etc.
        @nodes << k
        k = k + 1
      end
      @table << @row
    end
  end

  # flip table values horizontally
  def reverse_table
    @table_reversed = @table.reverse
  end

end
