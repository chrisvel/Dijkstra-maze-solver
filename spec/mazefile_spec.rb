require 'rspec'
require_relative '../lib/mazefile.rb'

describe MazeFile do
  subject(:mazefile) { MazeFile.new('data/maze.txt') }

  it { is_expected.to respond_to(:table_reversed) }
  it { is_expected.to respond_to(:data) }
  it { is_expected.to respond_to(:table) }

  it { is_expected.to respond_to(:read_file) }
  it { is_expected.to respond_to(:reverse_table) }

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
      expect(mazefile.table.flatten.length).to eq mazefile.table.length*mazefile.table.first.length
    end
    it { expect(mazefile.table).not_to be_empty }
    it { expect(mazefile.table.flatten).to include("S", "G", "0", "X") }
  end

  context "#reverse_table" do
    subject(:mazefile) { MazeFile.new('data/maze.txt') }

    it "creates a table with the right amount of data" do
      expect(mazefile.table_reversed.flatten.length).to eq mazefile.table.length*mazefile.table.first.length
    end
    it "reverses data successfully" do
      expect(mazefile.table_reversed).to eq(mazefile.table.reverse)
    end
    it { expect(mazefile.table_reversed).not_to be_empty }
  end

end
