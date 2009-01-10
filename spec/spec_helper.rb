require 'erb'

begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

def spec_attributes_of_new_object(klass, *attrs)
  attrs.last.is_a?(Hash) ? opts = attrs.pop : opts = {}
  
  attrs.each do |attribute|
    describe klass, "##{attribute} with new object" do
      before(:all) do
        @instance_without_data = klass.new
      end
      
      it "responds to #{attribute}" do
         @instance_without_data.should respond_to(attribute)
      end
      
      unless opts[:readonly]
        it "responds to #{attribute}=" do
           @instance_without_data.should respond_to(:"#{attribute}=")
        end
        
        it "returns the value from the edits if the #{attribute} is set" do
          @instance_without_data.send(:"#{attribute.to_s}=", "somestringtoprovevaluesetting")
          @instance_without_data.send(attribute).should_not be_nil
          @instance_without_data.edits.clear
        end
      end
              
      it "returns nil if #{attribute} is unset" do
        @instance_without_data.send(attribute).should be_nil
      end
    end
  end
end

def spec_child_entity_attributes_of_new_object(klass, *attrs)
  attrs.each do |attribute|
    describe klass, "#{attribute} subentity with new object" do
      before(:all) do
        @instance_without_data = klass.new
      end
      
      it 'exists' do
        @instance_without_data.should respond_to(attribute)
        @instance_without_data.send(attribute).should be_nil
      end
      
      it "can be set to a new #{attribute.to_s.classify} object" do
        @instance_without_data.should respond_to(:"#{attribute}=")
      end
    end
  end
end

def spec_child_entity_collection_attributes_of_new_object(klass, *attrs)
  
end

def spec_attributes_of_found_object(klass,id,*attrs)
  attrs.each do |attribute|
    describe klass, "##{attribute} with object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", true)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        
        @object.load_from_xml(xml)
      end
      
      it "can read the value for #{attribute} from xml if is set" do
        @object.send(attribute).should_not be_nil
      end
    end
    
    describe klass, "##{attribute} missing from object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", false)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        
        @object.load_from_xml(xml)
      end
      
      it "cannot read the value for #{attribute} from xml if is not set" do
        @object.send(attribute).should be_nil
      end
    end
  end
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rtunesu'