require 'rspec'
require_relative '../lib/mazefile.rb'

describe MazeFile do
  subject(:mazefile) { MazeFile.new('data/maze.txt') }

  it "has accessor for data" do
    is_expected.to respond_to(:data)
  end
  it "has accessor for table" do
    is_expected.to respond_to(:table)
  end
  it "has accessor for table_reversed" do
    is_expected.to respond_to(:table_reversed)
  end

  it "has method read_file" do
    is_expected.to respond_to(:read_file)
  end
  it "has method reverse_table" do
    is_expected.to respond_to(:reverse_table)
  end

  it "calls read_file when created" do
    expect_any_instance_of(MazeFile).to receive(:read_file)
    MazeFile.new('data/maze.txt')
  end
  it "calls reverse_table when created" do
    expect_any_instance_of(MazeFile).to receive(:reverse_table)
    MazeFile.new('data/maze.txt')
  end

  context "#read_file" do
    subject(:mazefile) { MazeFile.new('data/maze.txt') }

    it "@data value is equal to file content" do
      expect(mazefile.data).to eq(File.read('data/maze.txt'))
    end
    it "creates a table with the right amount of data" do
      expect(mazefile.table.flatten.length).to eq 48
    end
  end

  context "#reverse_table" do
    subject(:mazefile) { MazeFile.new('data/maze.txt') }

    it "creates a table with the right amount of data" do
      expect(mazefile.table_reversed.flatten.length).to eq 48
    end
    it "reverses data successfully" do
      expect(mazefile.table_reversed).to eq(mazefile.table.reverse)
    end
  end

end
