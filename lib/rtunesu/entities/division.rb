module RTunesU
  # A Division in iTunes U is a seperate nested area of your iTunes U Site.  It is different than a Section which is expressed in iTunes a a seperate area on a single page.
  # == Attributes
  # Handle
  # Name
  # Description
  # ShortName
  # AggregateFileSize (read only)
  # Identifier
  # LinkedFolderHandle
  # 
  #
  # == Nested Entities
  # Permission
  # Section
  # ThemeHandle
  class Division < Entity
    itunes_attribute :name, :description
    itunes_attribute :aggregate_file_size, :readonly => true
  end
end