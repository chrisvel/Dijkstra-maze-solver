# parses data from text files
class MazeFile

  attr_reader :data, :table, :table_reversed

  def initialize(file)
    @file = file
    @data = []
    @table = []
    @table_reversed = []
    read_file
    reverse_table
  end

  # reads data from the maze file to @table
  def read_file
    @data = File.read(@file)
    @data.strip.split(/[\l|\n\/]/).each do |line|
      row = []
      line.split(/ /).each { |item| row << item }
      @table << row
    end
  end

  # flip table values horizontally
  def reverse_table
    @table_reversed = @table.reverse
  end

end
