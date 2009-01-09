module RTunesU
  # A Course in iTunes U.
  # == Attributes
  # Name
  # Handle
  # Instructor
  # Description
  # Identifier
  # ThemeHandle
  # ShortName
  
  # == Nested Entities
  # Permission
  # Group

  class Course < Entity
     itunes_attribute :name, :instructor, :description, :short_name
     itunes_attribute :aggregate_file_size, :readonly => true
     itunes_child_entity :cover_image, :banner_image, :thumbnail_image
     itunes_child_entity_collection :groups, :permissions
  end
end