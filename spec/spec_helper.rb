begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'configer'


shared_examples_for "all environments" do
   it "should be able to use custom prefix" do
     lambda { MyApp }.should_not raise_error NameError
   end
     
   it "should have HOSTS constance" do
     lambda { Configer::HOSTS }.should_not raise_error NameError
   end

   it "should have EXTERNAL_SERVICES constance" do
     lambda { Configer::EXTERNAL_SERVICES }.should_not raise_error NameError
   end

    describe "hosts.yaml" do
      it "should match database" do
        @hosts['database'].each_pair do |key, value|
          Configer::HOSTS['database'][key].should == value
          MyApp::HOSTS['database'][key].should == value
        end
      end

      it "should match search_node" do
        @hosts['search_node'].each_pair do |key, value|
          Configer::HOSTS['search_node'][key].should == value
          MyApp::HOSTS['search_node'][key].should == value
        end
      end
    end

    describe "external_services.yaml" do
      it "should match amazon" do
        expected = @exernal_services['other_webservice']['api_key']
        Configer::EXTERNAL_SERVICES['other_webservice']['api_key'].should == expected
        MyApp::EXTERNAL_SERVICES['other_webservice']['api_key'].should == expected
      end
    end
end


