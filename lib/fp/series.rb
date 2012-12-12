require 'yaml'
require 'digest/sha1'
require 'fp/series_name'

module Fp
  class Series
    
    def initialize
      @series = Hash.new
      @display_index  = 1
      @data_directory = File.join(File.dirname(__FILE__), '..', '..', 'data')
    end

    def tag?(tagname)
      found = Hash.new
      tagname.each do |t|
          @series.select { |k,v| v.tags.include?(t) }.each do |k,v|
            found[k] = v
          end
      end
      found
    end

    def get_data_files
      files = Dir["#{@data_directory}/**/*"].reject {|fn| File.directory?(fn) }
      files.each do |f|
        load_data(f)
      end
    end

    private

    def load_data(filename)
      whisper_search_index = Fp::Whisper.new
      begin
        data = YAML::load( File.open(filename))
        if data.kind_of?(Array)
        else
          raise "#{filename} has no array defined, ignoring"
        end
        data.each do |s|
          begin
            raise "#{filename}: no tags option in YAML" unless s['tags']
            raise "#{filename}: no file option in YAML" unless s['file']
            raise "#{filename}: no name option in YAML" unless s['name']
            s['display_index'] = s['display_index'] ? s['display_index'].to_i : @display_index
          if s['regex'] and s['regex'] != ''
            results = whisper_search_index.search(s['regex'])
            results.each do |filename,match|
              name = Array.new
              name << s['name']
              name << match
              id = Digest::SHA1.hexdigest(filename)
              @series[id] = Fp::SeriesName.new( {
                :id            => id,
                :name          => name.join(" "),
                :file          => filename,
                :display_index => s['display_index'],
                :tags          => s['tags'].split(',')
              })
            end        
          else
            id = Digest::SHA1.hexdigest(s['file'])
            @series[id] = Fp::SeriesName.new( {
              :id            => id,
              :name          => s['name'],
              :file          => s['file'],
              :display_index => s['display_index'],
              :tags          => s['tags'].split(',')
            })
          end
          rescue Exception => e
            Rails.logger.error "Error in Fp::Series: #{e.message}"
          end
        end
      rescue Exception => e
        Rails.logger.error "Error in Fp::Series: #{e.message}"
      end  
    end
  end
end
