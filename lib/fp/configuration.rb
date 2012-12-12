module Fp
  class Configuration
    begin
      @settings = YAML::load_file('config/config.yml')[Rails.env]
    rescue Exception => e
      Rails.logger.fatal("Error loading configration file with RAILS_ENV=#{Rails.env}: #{e.message}")
    end

    def self.method_missing(key)
  		if @settings and @settings[key.to_s]
  			@settings[key.to_s]
  		else
        Rails.logger.fatal "Could not find key #{key.to_s} in ENV #{Rails.env}"
	  		raise "Could not find key #{key.to_s} in ENV #{Rails.env}"
	  	end
  	end
  end

end
