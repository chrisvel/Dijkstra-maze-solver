require 'rspec'
require_relative '../lib/mazesolver.rb'

describe MazeSolver do

  subject(:mazesolver) {
    maze_file = MazeFile.new('data/maze.txt')
    MazeSolver.new(maze_file.data, maze_file.table, maze_file.table_reversed)
  }

  it { is_expected.to respond_to(:table_merged) }
  it { is_expected.to respond_to(:table_x) }
  it { is_expected.to respond_to(:start_node) }
  it { is_expected.to respond_to(:goal_node) }
  it { is_expected.to respond_to(:shortest_path) }
  it { is_expected.to respond_to(:backtrack) }
  it { is_expected.to respond_to(:node_list) }
  it { is_expected.to respond_to(:nodes) }
  it { is_expected.to respond_to(:data) }
  it { is_expected.to respond_to(:table) }

  it { is_expected.to respond_to(:parse_maze) }
  it { is_expected.to respond_to(:create_nodes) }
  it { is_expected.to respond_to(:create_unvisited_set) }
  it { is_expected.to respond_to(:set_table_size) }
  it { is_expected.to respond_to(:create_node_list) }
  it { is_expected.to respond_to(:check_edges) }
  it { is_expected.to respond_to(:solve_dijkstra) }
  it { is_expected.to respond_to(:find_shortest_path) }

  it "calls #parse_maze when created" do
    expect_any_instance_of(MazeSolver).to receive(:parse_maze)
    maze_file = MazeFile.new('data/maze.txt')
    MazeSolver.new(maze_file.data, maze_file.table, maze_file.table_reversed)
  end
  it "calls #create_unvisited_set when created" do
    expect_any_instance_of(MazeSolver).to receive(:create_unvisited_set)
    maze_file = MazeFile.new('data/maze.txt')
    MazeSolver.new(maze_file.data, maze_file.table, maze_file.table_reversed)
  end
  it "calls #create_node_list when created" do
    expect_any_instance_of(MazeSolver).to receive(:create_node_list)
    maze_file = MazeFile.new('data/maze.txt')
    MazeSolver.new(maze_file.data, maze_file.table, maze_file.table_reversed)
  end

  context "#parse_maze" do
    it "should return a merged table as an Array" do
      expect(mazesolver.table_merged).to be_an_instance_of(Array)
    end
    it "should include mandatory nodes for main path" do
      expect(mazesolver.table_merged).to include("S", "G", "0", "X")
    end
    it "should return a converted table as an Array" do
      expect(mazesolver.instance_variable_get(:@table_convert)).to be_an_instance_of(Array)
    end
    it "should include start node in the right array value" do
       expect(mazesolver.table_merged[mazesolver.start_node]).to eq("S")
    end
  end
  context "#create_nodes" do
    it "should return nodes as an Array" do
      expect(mazesolver.nodes).to be_an_instance_of(Array)
    end
    it "should have the right amount of values" do
      expect(mazesolver.nodes.length).to eql(mazesolver.table.flatten.length)
    end
  end
  context "#create_unvisited_set" do
    it "should return the unvisited_set as an Array" do
      expect(mazesolver.instance_variable_get(:@unvisited_set)).to be_an_instance_of(Array)
    end
    it "should include the right amount of values" do
      expect(mazesolver.instance_variable_get(:@unvisited_set).length).to be_between(1, mazesolver.table_merged.length)
    end
  end
  context "#set_table_size" do
    it "should have the right size values" do
      expect(mazesolver.table_x).to eq(mazesolver.table.first.length)
      expect(mazesolver.instance_variable_get(:@table_y)).to eq(mazesolver.table.length)
    end
  end
  context "#create_node_list" do
    it "should return node_list as an Array" do
      expect(mazesolver.node_list).to be_an_instance_of(Array)
    end
    it "should include nodes as hashes" do
      expect(mazesolver.node_list.first).to be_an_instance_of(Hash)
    end
    it "should include neighbours as arrays" do
      expect(mazesolver.node_list.first[:neighs]).to be_an_instance_of(Array)
    end
    it "should include the right amount of nodes" do
      expect(mazesolver.node_list.length).to be_between(1, mazesolver.table_merged.length)
    end
    it "should include goal node within range" do
       expect(mazesolver.goal_node).to be_between(1, mazesolver.nodes.length)
    end
    it "should include goal node in the right array value" do
       expect(mazesolver.table_merged[mazesolver.goal_node]).to eq("G")
    end
  end
  context "#check_edges" do
    it "should return an Array" do
      (1..10).each { expect(mazesolver.check_edges(rand(0..mazesolver.nodes.length))).to be_an_instance_of(Array) }
    end
  end
  context "#solve_dijkstra" do
    it "should return an Array" do
      expect(mazesolver.solve_dijkstra).to be_an_instance_of(Array)
    end
  end
  context "#find_shortest_path" do
    it "should return an Array" do
      expect(mazesolver.instance_variable_get(:@shortest_path_coords)).to be_an_instance_of(Array)
    end
  end




end
