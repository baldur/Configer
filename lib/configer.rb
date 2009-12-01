$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'yaml'
require 'ruby-debug'

module Configer
  VERSION = '0.0.1'

  def self.init(params)
    opt = { :prefix => nil, 
            :path => File.dirname(__FILE__) + "/../spec/fixtures/",
            :environment => nil }.merge(params)
    remember_files = []
    Dir["#{opt[:path]}/*.yml","#{opt[:path]}/*.yaml"].each do |path_to_config_file|
      file_name = File.basename(path_to_config_file)
      remember_files << file_name
      config = file_name.gsub(/\.y(a)?ml/, "")
      value = YAML.load_file(path_to_config_file)
      if opt[:environment]
        path_with_environment = path_to_config_file.gsub(file_name, "#{opt[:environment]}/#{file_name}")
        value.merge!(YAML.load_file(path_with_environment))
      end
      const_set(config.upcase, value)
    end
    Dir["#{opt[:path]}/#{opt[:environment]}/*.yml","#{opt[:path]}#{opt[:environment]}/*.yaml"].each do |path_to_config_file|
      file_name = File.basename(path_to_config_file)
      unless remember_files.include?(file_name)
        config = file_name.gsub(/\.y(a)?ml/, "")
        value = YAML.load_file(path_to_config_file)
        const_set(config.upcase, value)
      end
    end
    Object.class_eval "#{opt[:prefix]} = #{Configer}"
  end

  def self.destroy_constants
    constants.each do |constant|
      unless constant == "VERSION"
        remove_const constant.to_sym
      end
    end
  end
end

