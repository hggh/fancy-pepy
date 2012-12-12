module Fp
  class Whisper
    def initialize
      unless File.readable?(Fp::Configuration.whisper_search_index)
        raise "Whisper file #{Fp::Configuration.whisper_search_index} not found"
      end
      @whisper_index = Array.new
      File.open(Fp::Configuration.whisper_search_index, "r").readlines.each do |l|
        @whisper_index << l.strip
      end
      
    end
    def search(regex)
      result = Hash.new
      @whisper_index.each do |w|
        if w =~ /#{regex}/
          name ||= $1
          result[w] = name
        end
      end
      result
    end
  end
end
