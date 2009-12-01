$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'yaml'
require 'ruby-debug'

module Configer
  VERSION = '0.0.1'

  def self.init(params)
    setting = Setting.new(params)
    Dir["#{setting.opt[:path]}/*.y*ml"].each do |path_to_config_file|
      file_name, config_name, value = setting.parse_yaml_info(path_to_config_file)
      if setting.opt[:environment]
        path_with_environment = path_to_config_file.gsub(file_name, "#{setting.opt[:environment]}/#{file_name}")
        value.merge!(YAML.load_file(path_with_environment))
      end
      const_set(config_name, value)
    end
    Dir["#{setting.opt[:path]}/#{setting.opt[:environment]}/*.y*ml"].each do |path_to_config_file|
      file_name = File.basename(path_to_config_file)
      unless setting.remember_files.include?(file_name)
        file_name, config_name, value = setting.parse_yaml_info(path_to_config_file)
        const_set(config_name, value)
      end
    end
    Object.class_eval "#{setting.opt[:prefix]} = #{Configer}"
  end

  def self.destroy_constants
    constants.each do |constant|
      unless %w(VERSION Setting).include?(constant)
        remove_const constant.to_sym
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/configer/*\.rb"].each do |file|
  require File.expand_path(file)
end

