module Fp
  class Graph
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :series_id, :graph_start, :graph_end

    def get_url
      ggraph = GraphiteGraph.new(:none)
      ggraph.width Fp::Configuration.graph_width
      ggraph.height Fp::Configuration.graph_height
      @series_id.each do |s|
        next if s == ""
        if @series and @series["#{s.to_s}"]
          serie = @series["#{s.to_s}"]
          ggraph.field s, :data  => serie.file,
                          :alias => serie.name
        end
      end
      url = Configuration.graphite_url + ggraph.url
      url
    end

    def initialize(series, attributes = {})
      @series = series
      attributes.each do |name, value|
       send("#{name}=", value)
       end
    end

    def persisted?
      false
    end
  end
end
