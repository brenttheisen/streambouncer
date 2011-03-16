module StreamBouncer
  class Application
    class << self
      attr_accessor :config
    end
  end
end

EXTERNAL_CONFIG_FILE_PATH = "#{::Rails.root.to_s}/config/streambouncer.yml"

if FileTest.exists?(EXTERNAL_CONFIG_FILE_PATH)
  config = YAML.load_file(EXTERNAL_CONFIG_FILE_PATH)
  config.merge!(config[::Rails.env]) unless config[::Rails.env].nil? 
  [ 'development', 'test', 'production'].each do |rails_env_name|
    config.delete(rails_env_name)
  end
  
  StreamBouncer::Application.config = config
  
  config['salt'] = 'whatever'
else
  
  StreamBouncer::Application.config = {
    'twitter_consumer_key' => ENV['TWITTER_CONSUMER_KEY'],
    'twitter_consumer_secret' => ENV['TWITTER_CONSUMER_SECRET'],
    'salt' => ENV['SALT']
  }
end
