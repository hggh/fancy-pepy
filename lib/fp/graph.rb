module Fp
  class Graph
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :series_id, :graph_start, :graph_end

    def get_series_info
      series = Array.new
      @series_id.delete_if {|x| x == '' }.each do |s|
        if @series and @series["#{s.to_s}"]
          series << @series["#{s.to_s}"]
        end
      end
      series
    end

    def get_url
      tags_config = Fp::Graphite::Tags.new
      ggraph = GraphiteGraph.new(:none)
      ggraph.width Fp::Configuration.graph_width
      ggraph.height Fp::Configuration.graph_height

      ggraph.from @graph_start if @graph_start != ''

      ggraph.major_grid_line_color Configuration.graph_major_grid_line_color
      ggraph.minor_grid_line_color Configuration.graph_minor_grid_line_color
      ggraph.background_color Configuration.graph_background_color
      ggraph.foreground_color Configuration.graph_foreground_color
      ggraph.fontsize Configuration.graph_fontsize

      # Don't display graph legend, we will do it
      #ggraph.hide_legend true

      @series_id.each do |s|
        next if s == ""
        if @series and @series["#{s.to_s}"]
          serie = @series["#{s.to_s}"]
          options = { :data  => serie.file, :alias => serie.name }
          # Pull Options for Graph Serie from SeriesName
          options.merge!(serie.graphite_options)
          ggraph.field s, options

          # Fetch Options for Tags
          serie.tags.each do |t|
            if tag = tags_config.tag?(t)
              tag.options.each do |o|
                ggraph.send("#{o}", tag.get_val(o))
              end
            end
          end
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
