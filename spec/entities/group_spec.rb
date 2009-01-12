require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object Group, :name, :group_type, :allow_subscription
spec_attributes_of_new_object Group, :aggregate_file_size, :readonly => true
spec_child_entity_attributes_of_new_object Group, :external_feed
spec_child_entity_collection_attributes_of_new_object Group, :tracks, :permissions

spec_attributes_of_found_object Group, 94505460, :name, :group_type, :allow_subscription
spec_attributes_of_found_object Group, 94505460, :aggregate_file_size, :readonly => true
spec_child_entity_attributes_of_found_object Group, 94505460, :external_feed
spec_child_entity_collection_attributes_of_found_object Group, 94505460, :tracks, :permissions