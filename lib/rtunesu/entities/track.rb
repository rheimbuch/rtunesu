module RTunesU
  # A Track in iTunes U.
  # == Attributes
  # Name
  # Handle
  # Kind
  # TrackNumber
  # DiscNumber
  # DurationMilliseconds
  # AlbumName
  # ArtistName
  # GenreName
  # DownloadURL
  # Comment
  class Track < Entity
    itunes_attribute :name, :kind, :track_number, :disc_number, 
                     :album_name, :artist_name, :genre_name, :comment
    itunes_attribute :duration_milliseconds, :download_url, :readonly => true
    
    
    # Tracks can only be found from within their Course. There is currently no way to find a Track separete from its Course in iTunes U.
    def self.find(handle, course_handle, connection)
      entity = self.new(:handle => handle)
      entity.source_xml = Course.find(course_handle, connection).source_xml.at("Handle[text()=#{entity.handle}]..")
      entity
    end
  end
end