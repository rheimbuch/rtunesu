module RTunesU
  # A Group in iTunes U. A Group is expressed as a tab in the iTunes interface.
  # == Attributes
  # Name
  # Handle
  # GroupType
  # ShortName
  # AggregateFileSize
  # AllowSubscription
  # 
  #
  # == Nested Entities
  # Permission
  # Track
  # SharedObjects
  # ExternalFeed
  
  class Group < Entity
    itunes_attribute :name
  end
end