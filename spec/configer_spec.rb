require File.dirname(__FILE__) + '/spec_helper.rb'

describe "after initialization" do

  before do
    @hosts = YAML.load_file(File.dirname(__FILE__) + "/../spec/fixtures/hosts.yaml")
    @exernal_services = YAML.load_file(File.dirname(__FILE__) + "/../spec/fixtures/external_services.yaml")
  end

  describe "with environment" do
    before do
      Configer.init(:prefix => 'MyApp', :environment => 'production')
      @hosts = YAML.load_file(File.dirname(__FILE__) + "/../spec/fixtures/production/hosts.yaml")
      @exernal_services = YAML.load_file(File.dirname(__FILE__) + "/../spec/fixtures/production/external_services.yaml")
    end

    it_should_behave_like "all environments"

    it "should add configs from files in environment folder" do
      MyApp::EXTERNAL_SERVICES['only_in_production']['that_right'].should == "sure is"
    end

  end

  describe "with default environment" do
    before do
      Configer.init(:prefix => 'MyApp')
    end

    it_should_behave_like "all environments"

    it "should merge and not trash default settings" do
      MyApp::EXTERNAL_SERVICES['only_in_default']['that_right'].should == "sure is"
    end

  end

  after do
    Configer.destroy_constants
    Object.send(:remove_const, :MyApp)
  end
end

