module Fp
  class Graph
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :series_id, :graph_start, :graph_end

    def get_url
      ggraph = GraphiteGraph.new(:none)
      ggraph.width Fp::Configuration.graph_width
      ggraph.height Fp::Configuration.graph_height

      ggraph.from @graph_start if @graph_start != ''

      ggraph.major_grid_line_color Configuration.graph_major_grid_line_color
      ggraph.minor_grid_line_color Configuration.graph_minor_grid_line_color
      ggraph.background_color Configuration.graph_background_color
      ggraph.foreground_color Configuration.graph_foreground_color
      ggraph.fontsize Configuration.graph_fontsize

      @series_id.each do |s|
        next if s == ""
        if @series and @series["#{s.to_s}"]
          serie = @series["#{s.to_s}"]
          options = { :data  => serie.file, :alias => serie.name }
          # Pull Options for Graph Serie from SeriesName
          options.merge!(serie.graphite_options)
          ggraph.field s, options
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
