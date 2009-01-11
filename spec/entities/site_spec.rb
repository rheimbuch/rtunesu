require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object Site, :name, :theme_handle, :login_url, :allow_subscription
spec_attributes_of_new_object Site, :aggregate_file_size, :readonly => true
# spec_child_entity_attributes_of_new_object Site, :link_collection_set
spec_child_entity_collection_attributes_of_new_object Site, :permissions, :sections

spec_attributes_of_found_object Site, 27361720, :name, :theme_handle, :login_url, :allow_subscription
spec_attributes_of_found_object Site, 27361720, :aggregate_file_size, :readonly => true
# spec_child_entity_attributes_of_found_object Site, 27361720, :link_collection_set
spec_child_entity_collection_attributes_of_found_object Site, 27361720, :permissions, :sections