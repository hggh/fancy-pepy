module Fp
  class SeriesName
    attr_accessor :id, :name, :file, :display_index, :tags
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  end
end
