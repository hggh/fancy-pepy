module Fp
  class SeriesName

    attr_accessor :id, :name, :file, :display_index, :tags

    def initialize(attributes = {})
      @graphite_options = Hash.new
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def graphite_options
      @graphite_options
    end

    def graphite=(value = [])
      if value.kind_of?(Array)
        value.each do |v|
          v.map { |k,v|  @graphite_options[k.to_sym] = v }
        end
      end
    end

  end
end
