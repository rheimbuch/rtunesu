require 'hpricot'

module RTunesU
  # A Base class reprenseting the various entities seen in iTunes U.  Subclassed into the actual entity classes (Course, Division, Track, etc).  Entity is mostly an object oriented interface to the underlying XML data returned from iTunes U.  Most of attributes of an Entity are read by searching the souce XML returned from iTunes U by the Entity class's implemention of method_missing. 
  # Attribute of an Entity are written through method missing as well.  Methods that end in '=' will write data that will be saved to iTunes U.
  # == Reading and Writing Attributes
  # RTunesU::Connection.establish_connection(:user_id =>19248, 
  # :user_username =>'admin',
  # :user_name => 'Admin',
  # :user_email => 'admin@example.edu',
  # :user_credentials => ['Administrator@urn:mace:example.edu'],
  # :site => 'example.edu', 
  # :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
  # 
  # c = Course.find(12345) # finds the Course in iTunes U and stores its XML data
  # c.handle # finds the <Handle> element in the XML data and returns its value (in this case 12345)
  # c.name   # finds the <Name> element in the XML data and returns its value (e.g. 'My Example Course'), or nil
  # c.name = 'Podcasting: a Revolution' # writes a hash of unsaved data that will be sent to iTunes U.
  #
  # == Accessing related entities 
  # Related Entity objects are accessed with the pluralized form of their class name.  To access a Course's related Group entities, you would use c.groups. This will return an EntityCollection of Group objects (or an empty EntityCollection object if there are no associated Groups)
  # You can set the array of associated entities by using the '=' form of the accessor and add anothe element to the end of an array of related entities with '<<'
  # Examples:
  # c = Course.find(12345) # finds the Course in iTunes U and stores its XML data
  # c.groups # returns an array of Group entities or an empty array of there are no Group entities
  # c.groups = Groups.new(Group.new(:Name => 'Lectures')) # assigns the Groups related entity array to an existing Groups object (overwriting any local data about Groups)
  # c.groups << Group.new(:Name => 'Videos') # Adds the new Group object to the end of hte Groups array
  # c.groups.collect {|g| g.Name} # ['Lectures', 'Videos']
  #
  class Entity
    attr_accessor :connection, :attributes, :handle, :parent, :parent_handle, :saved, :source_xml
    
    def self.itunes_attribute(*args)
      args.last.is_a?(Hash) ? options = args.pop : options = {}
      args.each do |method|
        define_method(method) do
          begin
            self.edits[method] || (self.source_xml % method.to_s.camelize).innerHTML
          rescue NoMethodError
            nil
          end
        end
      
        unless options[:readonly]
          define_method("#{method.to_s}=") do |val|
            self.edits[method] = val
          end
        end
      end
    end
    
    def self.itunes_child_entity(*args)
      args.last.is_a?(Hash) ? options = args.pop : options = {}
      
      args.each do |method|
        define_method(method) do
          begin
            self.accesses[method] ||= method.to_s.camelize.constantize.from_xml((self.source_xml % method.to_s.camelize).innerHTML)
          rescue NoMethodError
            nil
          end
        end
      
        define_method("#{method.to_s}=") do |obj|
          self.accesses[method] = obj
        end
      end
    end
    
    def self.itunes_child_entity_collection(*args)
      args.last.is_a?(Hash) ? options = args.pop : options = {}
      
      args.each do |method|
        define_method(method) do
          begin
            self.accesses[method] ||= method.to_s.camelize.constantize.from_xml(self.source_xml / "/#{method.to_s.singularize.camelize}")
          rescue NoMethodError
            self.accesses[method] = method.to_s.camelize.constantize.new
          end
        end
      
        define_method("#{method.to_s}=") do |obj|
          self.accesses[method] = obj
        end
      end
    end
    
    # Creates a new Entity object with attributes based on the hash argument  Some of these attributes are assgined to instance variables of the obect (if there is an attr_accessor for it), the rest will be written to a hash of edits that will be saved to iTunes U using method_missing
    def initialize(attrs = {})
      self.attributes = {}
      attrs.each {|attribute, value| self.send("#{attribute}=", value)}
      return self
    end
        
    def self.establish_connection(options)
      # :user_id =>0, 
      # :user_username =>'admin',
      # :user_name => 'Admin',
      # :user_email => 'admin@example.com',
      # :user_credentials => ['Administrator@urn:mace:example.edu'],
      # :site => 'example.edu', 
      # :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS'
      @connection = RTunesU::Connection.new(options)
    end
    
    def self.connection
      @connection
    end
    
    # Finds a specific entity in iTunes U. To find an entity you will need to know both its type (Course, Group, etc) and handle.  Handles uniquely identify entities in iTunes U and the entity type is used to search the returned XML for the specific entity you are looking for.  For example,
    # Course.find(123456, rtunes_connection_object)
    def self.find(handle)
      entity = self.new(:handle => handle)
      entity.load_from_xml(Entity.connection.process(Document::ShowTree.new(entity).xml))
      entity
    end
    
    # creats a new instance from parsed xml
    def self.from_xml(xml)
      instance = self.new()
      instance.source_xml = xml
      return instance
    end
      
    # loads parsed xml data into an existing instance  
    def load_from_xml(xml)
      self.source_xml = Hpricot.XML(xml).at("//ITunesUResponse//#{self.class_name}//Handle[text()=#{self.handle}]..")
      raise EntityNotFound if self.source_xml.nil?
    end
    
    # Edits stores the changes made to an entity
    def edits
      @edits ||= {}
    end
    
     # Accesses stores the child entities accessed from the source xml
    def accesses
      @accesses ||= {}
    end
    
    # Clear the edits and restores the loaded object to its original form
    def reload
      self.edits.clear
      self.accesses.clear
      return self
    end
    
    # Returns the parent of the entity
    def parent
      @parent ||= Object.module_eval(self.source_xml.parent.name).new(:source_xml => self.source_xml.parent)
    rescue
      nil
    end
        
    # Returns the name of the object's class ignoring namespacing. 
    # === Use:
    # course = RTunesU::Course.new
    # course.class #=> 'RTunesU::Course'
    # course.class_name #=> 'Course'
    def class_name
      self.class.to_s.split('::').last
    end
    
    # Returns the handle of the entitiy's parent.  This can either be set directly as a string or interger or will access the parent entity.  Sometimes you know the parent_handle without the parent object (for example, stored locally from an earlier request). This allows you to add a new Entity to iTunes U without first firing a reques for a prent entity (For example, if your institution places all inside the same Section, you want to add a new Section to your Site, or a new Group to a course tied to your institution's LMS).
    def parent_handle
      self.parent ? self.parent.handle : @parent_handle
    end
    
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!(self.class_name) {
        self.edits.each {|attribute,edit| xml_builder.tag!(attribute.to_s.camelize, edit) }
        self.accesses.each {|entity_name, entity| entity.to_xml(xml_builder) if entity.edited? }    
      }
    end
    
    # called when .save is called on an object that is already stored in iTunes U
    def update
      Entity.connection.process(Document::Merge.new(self).xml)
      self
    end
    
    # called when .save is called on an object that has no Handle (i.e. does not already exist in iTunes U)
    def create
      response = Hpricot.XML(Entity.connection.process(Document::Add.new(self).xml))
      raise Exception, response.at('error').innerHTML if response.at('error')
      self.handle = response.at('AddedObjectHandle').innerHTML
      self
    end
    
    # Saves the entity to iTunes U.  Save takes single argument (an iTunes U connection object).  If the entity is unsaved this will create the entity and populate its handle attribte.  If the entity has already been saved it will send the updated data (if any) to iTunes U.
    def save
      saved? ? update : create
    end
    
    # TODO: rename to new?
    def saved? 
      self.handle ? true : false
    end
    
    # TODO: rename to saved?
    def edited?
      !self.edits.empty? || !self.accesses.empty?
    end
    
    # Deletes the entity from iTunes U.  This cannot be undone.
    def delete
      response = Hpricot.XML(Entity.connection.process(Document::Delete.new(self).xml))
      raise Exception, response.at('error').innerHTML if response.at('error')
      self.handle = nil
      self
    end
  end
  
  # Error class raised when Entity.find does not return an entity
  class EntityNotFound < Exception
  end
  
  # Error class raised when Entity#save is called for an entity instance that does not have a parent_handle attribute
  class MissingParent < Exception
  end
  
  # oddball child entities that cannot save on their own
  # Images
  class EntityImage < Entity
    itunes_attribute :shared
  end
  class CoverImage < EntityImage;end
  class BannerImage < EntityImage;end
  class ThumbnailImage < EntityImage;end
  #LinkCollection. WTH Apple.
  class LinkCollection < Entity
    itunes_attribute :name, :feed_url
  end
  
  class ExternalFeed < Entity
    itunes_attribute :url, :owner_email, :polling_interval
  end
end