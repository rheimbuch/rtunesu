module RTunesU
  # A Section in iTunes U.  A Section is expressed in the iTunes interface as a visually seperate area on a single page.  This is different than a Division which is a seperate nested area of iTunes U.
  # == Attributes
  # Handle
  # Name
  # AllowSubscription
  # AggregateFileSize
  # 
  # == Nested Entities
  # Permission
  # Course
  # Division
  class Section < Entity
    itunes_attribute :name, :allow_subscription
    itunes_attribute :aggregate_file_size, :readonly => true
    itunes_child_entity_collection :divisions, :courses, :permissions
  end
end