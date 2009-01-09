module RTunesU
  # A Permission in iTunes U.
  # == Attributes
  # Credential
  # Access
  # 
  # == Nested Entities
  class Permission < Entity
    itunes_attribute :credential, :access
  end
end