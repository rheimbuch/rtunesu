require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object(Course, :name, :instructor, :description, :short_name)
spec_attributes_of_new_object(Course, :aggregate_file_size, :readonly => true)
spec_child_entity_attributes_of_new_object(Course, :cover_image, :banner_image, :thumbnail_image)
spec_child_entity_collection_attributes_of_new_object(Course, :groups, :permissions)

spec_attributes_of_found_object(Course, 27362036, :name, :instructor, :description, :short_name)
spec_attributes_of_found_object(Course, 27362036, :aggregate_file_size, :readonly => true)

spec_child_entity_attributes_of_found_object(Course, 27362036, :cover_image, :banner_image, :thumbnail_image)
spec_child_entity_collection_attributes_of_found_object(Course, 27362036, :groups, :permissions)


# describe Course, 'converting to xml' do
#   before do
#     @course = Course.new
#   end
#   
#   it 'can convert attributes' do
#     @course.name = 'the name'
#     @course.to_xml.should eql('<Course><Name>the name</Name></Course>')
#   end
#   
#   it 'can covnert a child entity' do
#     @course.name = 'the name'
#     @course.cover_image = CoverImage.new(:shared => false)
#     @course.to_xml.should eql('<Course><Name>the name</Name><CoverImage><Shared>false</Shared></CoverImage></Course>')
#   end
#   
#   it 'can convert a child as an entity collections' do
#     @course.name = 'the name'
#     @course.groups << Group.new(:name => 'g name')
#     @course.to_xml.should eql("<Course><Name>the name</Name><Group><Name>g name</Name></Group></Course>")
#   end
#   
#   it 'can convert many children in an entity collection' do
#     @course.name = 'the name'
#     @course.groups << Group.new(:name => 'g name')
#     @course.groups << Group.new(:name => 'g name deux')
#     @course.to_xml.should eql("<Course><Name>the name</Name><Group><Name>g name</Name></Group><Group><Name>g name deux</Name></Group></Course>")
#   end
# end
# 
# 
# 
# 
# describe Course, "iTunes U interaction" do
#   before do
#     @connection = Entity.establish_connection(:user_id =>0, 
#                                 :user_username =>'admin',
#                                 :user_name => 'Admin',
#                                 :user_email => 'admin@example.com',
#                                 :user_credentials => ['Administrator@urn:mace:example.edu'],
#                                 :site => 'example.edu', 
#                                 :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
#   end
#   
#   describe 'finding' do
#     it 'can find itself in iTunesU' do
#       @connection.should_receive(:process).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
#       @course = Course.find(1257981186)
#     end
#   end
# end
#   # 
#   # describe 'attribute access' do
#   #   before(:each) do
#   #     @connection.should_receive(:process).at_least(:once).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
#   #     @saved_course = Course.find(1257981186)
#   #     @unsaved_course = Course.new
#   #     @will_be_saved_course = Course.new
#   #   end
#   #   
#   # describe 'saving' do
#   #   before(:each) do
#   #     @connection.should_receive(:process).at_least(:once).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
#   #     @saved_course = Course.find(1257981186)
#   #     @unsaved_course = Course.new(:parent_handle => 1)
#   #     @will_be_saved_course = Course.new(:parent_handle => 1)
#   #   end
#   #   
#   #   it 'tells if you if it is unsaved' do
#   #     @unsaved_course.saved?.should be_false
#   #   end
#   #   
#   #   it 'tells if you if it has been saved' do
#   #     @saved_course.saved?.should be_true
#   #   end
#   #   
#   #   it 'can save'
#   #   
#   #   it 'can update' do
#   #    lambda { @saved_course.update }.should_not raise_error
#   #   end
#   #   
#   #   it 'can create if unsaved'
#   #   
#   #   it 'cannot create an already created coures'
#   #   
#   #   it 'calls update if saved?'
#   #   
#   #   it 'calls create if unsaved?'
#   # end
# # end