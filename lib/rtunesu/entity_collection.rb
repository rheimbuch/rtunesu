class EntityCollection < Array
  def self.from_xml(parsed_xml)
    singular_classname_as_string = self.to_s.singularize
    singular_classname = singular_classname_as_string.constantize
    instance = self.new
    parsed_xml.each do |single_item|
      instance << singular_classname.from_xml(single_item)
    end
    return instance
  end
  
  def to_xml(xml_builder = Builder::XmlMarkup.new)
    self.each {|entity| xml_builder << entity.to_xml() if entity.edited? }
    return ''
  end
  
  # polymorhpic. the existence of this implies edit.
  def edited?
    true
  end
end

class Divisions < EntityCollection; end
class Courses < EntityCollection; end
class Groups < EntityCollection; end
class Permissions < EntityCollection; end
class Sections < EntityCollection; end
class Themes < EntityCollection; end
class Tracks < EntityCollection; end
class LinkCollectionSet < EntityCollection; end #Apple, WTH, really.