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
    itunes_attribute :name, :short_name, :group_type, :allow_subscription
    itunes_attribute :aggregate_file_size, :readonly => true
    itunes_child_entity :external_feed
    itunes_child_entity_collection :tracks, :permissions
  end
end