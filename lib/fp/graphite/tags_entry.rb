require 'yaml'
module Fp
  class Graphite
    class TagsEntry
      
      attr_reader :name
    
      def initialize(tagname, options = [])
        @name = tagname
        @options = Hash.new
        options.each do |o|
          o.map { |k,v| 
            @options[k.gsub(/graphite_/, '')] = v 
          }
        end
      end

      def get_val(option)
        if @options and @options[option]
          @options[option].to_s
        else
          false
        end
      end

      def options
        @options.keys
      end

      def self.method_missing(key)
        if @options and @options[key]
          @options[key].gsub(/graphite_/, '')
        else
          false
        end
      end

    end
  end
end
