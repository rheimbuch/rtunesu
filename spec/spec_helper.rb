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
  attrs.each do |attribute|
    describe klass, "#{attribute} subentity collection with new object" do
      before(:all) do
        @subentity_collection_class = attribute.to_s.capitalize.constantize
        @instance_without_data = klass.new
      end
      
      it "returns an empty entity collection object of the correct type for #{attribute}" do
        @instance_without_data.send(attribute).should be_kind_of(@subentity_collection_class)
        @instance_without_data.send(attribute).should be_empty
      end
    end
  end
end

def spec_attributes_of_found_object(klass,id,*attrs)
  attrs.last.is_a?(Hash) ? opts = attrs.pop : opts = {}
  
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
      
      unless opts[:readonly]
        it "can set the value for #{attribute} to something new" do
          lambda { @object.send(:"#{attribute}=", 'some new value') }.should_not raise_error
        end
      
        it "reads the new set value for #{attribute}, ignoring the xml, when #{attribute} is set to something new" do
          @object.send(:"#{attribute}=", 'some new value')
          @object.send(attribute).should eql('some new value')
        end
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

def spec_child_entity_attributes_of_found_object(klass,id,*attrs)
  attrs.each do |attribute|
    describe klass, "##{attribute} subentity with object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", true)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        
        @object.load_from_xml(xml)
      end
      
      it "can access its #{attribute} child entity from xml" do
        @object.send(attribute).should be_kind_of(attribute.to_s.classify.constantize)
      end
      
      it "can set its #{attribute} to a new object" do
        new_subentity =  attribute.to_s.classify.constantize.new
        @object.send(:"#{attribute}=",new_subentity)
        @object.send(attribute).should equal(new_subentity)
      end
    end
  
    describe klass, "##{attribute} subentity missing from object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", false)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        
        @object.load_from_xml(xml)
      end
      
      it "cannot read the value for #{attribute} subentity from xml if is not set" do
         @object.send(attribute).should be_nil
      end      
    end
  end
end

def spec_child_entity_collection_attributes_of_found_object(klass,id,*attrs)
  attrs.each do |attribute|
    describe klass, "##{attribute} subentity collection with object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        @subentity_collection_class = attribute.to_s.capitalize.constantize
        @subentity_collection_item_class = attribute.to_s.singularize.capitalize.constantize
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", true)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        puts xml
      end
      
      it "returns an entity collection object of the correct type for #{attribute}" do
        @object.send(attribute).should be_kind_of(@subentity_collection_class)
      end
      
      it "has an entity collection object filled with objects of correct type for #{attribute}" do
         @object.send(attribute).should_not be_empty
         @object.send(attribute).first.should be_kind_of(@subentity_collection_item_class)         
      end
      
    end
    
    describe klass, "##{attribute} subentity collection missing from object loaded from iTunes U" do
      before(:all) do
        @object = klass.new(:handle => id)
        @subentity_collection_class = attribute.to_s.capitalize.constantize
        
        class_as_string = klass.to_s.split("::").last.downcase
        
        instance_variable_set("@#{class_as_string}_entity",true)
        instance_variable_set("@#{class_as_string}_#{attribute.to_s}", false)
        
        xml = ERB.new(File.read(File.dirname(__FILE__) + '/fixtures/responses/show_tree.xml')).result(binding)
        
        @object.load_from_xml(xml)
      end
      
      it "returns an empty entity collection object of the correct type for #{attribute}" do
        @object.send(attribute).should be_kind_of(@subentity_collection_class)
        @object.send(attribute).should be_empty
      end
    end
  end
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rtunesu'