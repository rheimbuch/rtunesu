module RTunesU
  # A Site in iTunes U.
  # == Attributes
  # Name
  # Handle
  # AllowSubscription
  # AggregateFileSize
  # ThemeHandle
  # LoginURL
  
  # == Nested Entities
  # Permission
  # Theme
  # LinkCollectionSet
  # Section
  class Site < Entity
    itunes_attribute :name, :instructor, :theme_handle, :login_url, :allow_subscription
    itunes_attribute :aggregate_file_size, :readonly => true
    itunes_child_entity :link_collection_set
    itunes_child_entity_collection :permissions, :sections
  end
end