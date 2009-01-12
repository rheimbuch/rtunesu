require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object(Section, :name, :allow_subscription)
spec_attributes_of_new_object(Section, :aggregate_file_size, :readonly => true)
spec_child_entity_collection_attributes_of_new_object(Section, :divisions, :courses, :permissions)

spec_attributes_of_found_object(Section, 27362003, :name, :allow_subscription)
spec_attributes_of_found_object(Section, 27362003, :aggregate_file_size, :readonly => true)
spec_child_entity_collection_attributes_of_found_object(Section, 27362003, :divisions, :courses, :permissions)