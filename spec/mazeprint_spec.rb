require 'rspec'
require_relative '../lib/mazeprint.rb'

describe MazePrint do

  subject(:mazeprint) {
    maze_file = MazeFile.new('data/maze.txt')

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
    MazePrint.new(*args)
  }

  it { is_expected.to respond_to(:print_table_reverse) }
  it { is_expected.to respond_to(:print_stats) }
  it { is_expected.to respond_to(:print_nodes_final) }

  context "#print_table_reverse" do
    it "should output to stdout" do
      expect { mazeprint.print_table_reverse }.to output.to_stdout
    end
    it "includes \"X\" in output to stdout" do
      expect { mazeprint.print_table_reverse }.to output(/X/).to_stdout
    end
    it "includes \"G\" in output to stdout" do
      expect { mazeprint.print_table_reverse }.to output(/G/).to_stdout
    end
    it "includes \"S\" in output to stdout" do
      expect { mazeprint.print_table_reverse }.to output(/S/).to_stdout
    end
    it "includes \"0\" in output to stdout" do
      expect { mazeprint.print_table_reverse }.to output(/0/).to_stdout
    end
    it "does not print an error to stdout" do
      expect { mazeprint.print_table_reverse }.to_not output.to_stderr
    end
  end

  context "#print_stats" do
    it "should output to stdout" do
      expect { mazeprint.print_stats }.to output.to_stdout
    end
    it "does not print an error to stdout" do
      expect { mazeprint.print_table_reverse }.to_not output.to_stderr
    end
  end

  context "#print_nodes_final" do
    it "should output to stdout" do
      expect { mazeprint.print_nodes_final }.to output.to_stdout
    end
    it "does not print an error to stdout" do
      expect { mazeprint.print_table_reverse }.to_not output.to_stderr
    end
  end

end
