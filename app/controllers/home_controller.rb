class HomeController < ApplicationController
  def index
  end

  def tag
    @tagname = request[:tagname]
    graphite_series = Fp::Series.new
    graphite_series.get_data_files
    @series = graphite_series.tag?(@tagname.split(','))
    @graph = Fp::Graph.new(@series)
  end
end
