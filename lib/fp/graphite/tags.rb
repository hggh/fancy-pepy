require 'yaml'
module Fp
  class Graphite
    class Tags
      attr_reader :tags

      def initialize
        @tags = Hash.new
        @data_directory = File.join(File.dirname(__FILE__), '..', '..', '..', 'data', 'tags')
        get_data_files
      end

      def get_data_files
        files = Dir["#{@data_directory}/**/*"].reject {|fn| File.directory?(fn) }
        files.each do |f|
          load_data(f)
        end
      end

      def tag?(tagname)
        if @tags and @tags[tagname]
            @tags[tagname]
        else
          nil
        end
      end

      private
      
      def load_data(filename)
        begin
          data = YAML::load( File.open(filename))
          unless data.kind_of?(Array)
            Rails.logger.error "Config file #{filename} has got no Arrays defined."
            raise "#{filename} has no array defined, ignoring"
          end
          data.each do |t|
            tagname = t["tag"]
            @tags[tagname] = Fp::Graphite::TagsEntry.new(tagname, t["options"])
          end
        rescue Exception => e
          raise e.message
          Rails.logger.error "Error in Fp::Graphite::Tags: #{e.message}"
        end
      end
    end
  end
end
