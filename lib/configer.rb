$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'yaml'
require 'ruby-debug'

module Configer
  VERSION = '0.0.1'

  def self.init(prefix=nil, path=File.dirname(__FILE__) + "/../spec/fixtures/")
    Dir["#{path}/*.yml","#{path}/*.yaml"].each do |path_to_config_file|
      config = File.basename(path_to_config_file).gsub(/\.y(a)?ml/, "")
      const_set(config.upcase, YAML.load_file(path_to_config_file))
    end
    Object.class_eval "#{prefix} = #{Configer}"
  end

  def self.destroy_constants
    constants.each do |constant|
      unless constant == "VERSION"
        remove_const constant.to_sym
      end
    end
  end
end

