class GraphController < ApplicationController
  def draw
    @tagname = request[:tagname] ? request[:tagname] : String.new
    graphite_series = Fp::Series.new
    graphite_series.get_data_files
    @series = graphite_series.tag?(@tagname.split(','))
    @graph = Fp::Graph.new(@series, request[:fp_graph])
    @graph_url = @graph.get_url
  end
end
