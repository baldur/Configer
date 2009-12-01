module Configer
  class Setting
    attr_accessor :opt, :remember_files
    def initialize(params)
      @opt = { :prefix => nil, 
               :path => File.dirname(__FILE__) + "/../../spec/fixtures/",
               :environment => nil }.merge(params)
      @remember_files = []
    end

    def parse_yaml_info(full_path)
      file_name = File.basename(full_path)
      @remember_files << file_name 
      config_name = file_name.gsub(/\.y(a)?ml/, "").upcase
      value = YAML.load_file(full_path)
      return file_name, config_name, value
    end
  end
end

