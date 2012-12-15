class GraphitesController < ApplicationController
  def draw
    @tagname = request[:tagname] ? request[:tagname] : String.new
    graphite_series = Fp::Series.new
    @series = graphite_series.tag?(@tagname.split(','))
    @graph = Fp::Graph.new(@series, request[:fp_graph])
    @graph_url = @graph.get_url
  end

  def index
    graphite_series = Fp::Series.new
    @tags = graphite_series.tags
  end

  def tag
    @tagname = request[:tagname]
    graphite_series = Fp::Series.new
    graphite_series.get_data_files
    @series = graphite_series.tag?(@tagname.split(','))
    @graph = Fp::Graph.new(@series)
  end
end
