require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object Track, :name, :kind, :track_number, :disc_number, :album_name, :artist_name, :genre_name, :comment
spec_attributes_of_new_object Track, :duration_milliseconds, :download_url, :readonly => true