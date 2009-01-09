require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

spec_attributes_of_new_object(Course, :name, :instructor, :description, :short_name)
spec_attributes_of_new_object(Course, :aggregate_file_size, :readonly => true)
spec_child_entity_attributes_of_new_object(Course, :cover_image, :banner_image, :thumbnail_image)
spec_child_entity_collection_attributes_of_new_object(Course)


describe Course, 'converting to xml' do
  before do
    @course = Course.new
  end
  
  it 'can convert attributes' do
    @course.name = 'the name'
    @course.to_xml.should eql('<Course><Name>the name</Name></Course>')
  end
  
  it 'can convert a child as an entity collections' do
    @course.name = 'the name'
    @course.groups << Group.new(:name => 'g name')
    @course.to_xml.should eql("<Course><Name>the name</Name><Group><Name>g name</Name></Group></Course>")
  end
  
  it 'can convert many children in an entity collection' do
    @course.name = 'the name'
    @course.groups << Group.new(:name => 'g name')
    @course.groups << Group.new(:name => 'g name deux')
    @course.to_xml.should eql("<Course><Name>the name</Name><Group><Name>g name</Name></Group><Group><Name>g name deux</Name></Group></Course>")
  end
end

describe Course, 'loading from xml' do
  before do
    @data = File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml')
  end
  
  it 'can load XML data retrived from iTunes U' do
    @course = Course.new(:handle => 1257981186)
    lambda { @course.load_from_xml(@data) }.should_not raise_error
  end
end

describe Course, 'accessing attributes from xml or local data' do
  before do
   @course = Course.new(:handle => 1257981186)
   @course.load_from_xml(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  end
  
  it 'can access attributes through its source xml' do
    @course.name.should eql('SI 539 001 W07')
  end
  
  it 'can access local data' do
    @course.instructor = 'James'
    @course.instructor.should eql('James')
  end
  
  it 'returns nil for data that is in neither xml source or local data' do
    @course.instructor.should be_nil
  end
end

describe Course, 'accessing child entities' do
  before do
    @course = Course.new(:handle => 1257981186)
    @course.load_from_xml(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  end
  
  it 'can access its child entities from xml' do    
    @course.cover_image.should be_kind_of(CoverImage)
  end
  
  it 'returns nil for child entities that do not exist' do
    @course.banner_image.should be_nil
  end
end

describe Course, 'accessing child entity collections' do
  before do
    @course = Course.new(:handle => 1257981186)
    @course.load_from_xml(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  end
  
  it 'can access its child entities collections from xml' do    
    @course.groups.should_not be_nil
  end
  
  it 'child entity collections accessed through xml return an array' do
    @course.groups.should be_kind_of(Array)
  end
  
  it 'child entity collections accessed through xml should contain objects typed to the child relationship' do
    @course.groups.first.should be_kind_of(Group)
  end
  
  it 'can access relationships with no xml data and return an empty array' do
    @course.permissions.should be_empty
  end
  
end

# describe Course do
  # before do
  #   @connection = Entity.establish_connection(:user_id =>0, 
  #                               :user_username =>'admin',
  #                               :user_name => 'Admin',
  #                               :user_email => 'admin@example.com',
  #                               :user_credentials => ['Administrator@urn:mace:example.edu'],
  #                               :site => 'example.edu', 
  #                               :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
  # end
  # 
  # describe 'finding' do
  #   it 'can find itself in iTunesU' do
  #     @connection.should_receive(:process).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  #     @course = Course.find(1257981186)
  #   end
  # end
  # 
  # describe 'attribute access' do
  #   before(:each) do
  #     @connection.should_receive(:process).at_least(:once).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  #     @saved_course = Course.find(1257981186)
  #     @unsaved_course = Course.new
  #     @will_be_saved_course = Course.new
  #   end
  #   
  #   describe 'Course#parent_handle' do
  #     it 'must exist'
  #     it 'is not optional'
  #     it 'cannot be updated'
  #   end
  #   
  #   describe 'Course#parent_path' do
  #     it 'must exist'
  #     it 'is not optional'
  #     it 'can be blank'
  #     it 'cannot be updated'
  #   end
  #   
  #   describe 'Course#name' do
  #     it 'can exist'
  #     it 'is optional'
  #     it 'can be updated'
  #   end
  #   
  #   describe 'Course#handle' do
  #     it 'exists if saved'
  #     it 'is missing until save'
  #     it 'is readonly'
  #     it 'is not optional'
  #   end
  #   
  #   describe 'Course#instructor' do
  #     it 'is optional'
  #     it 'can be updated'
  #   end
  #   
  #   describe 'Course#description' do
  #     it 'is optional'
  #     it 'can be updated'
  #   end
  #   
  #   describe 'Course#permission' do
  #     it 'is a Permission object'
  #     it 'is optional'
  #     it 'has a default value' #?
  #   end
  #   
  #   describe 'Course#cover_image' do
  #     it 'is a CoverImage object'
  #     it 'is optional'
  #     it 'has a default value' #?
  #   end
  #   
  #   describe 'Course#banner_image' do
  #     it 'is a BannerImage object'
  #     it 'is optional'
  #     it 'has a default value' #?
  #   end
  #   
  #   describe 'Course#thumbnail_image' do
  #     it 'is a ThumbnailImage object'
  #     it 'is optional'
  #     it 'has a default value' #?
  #   end
  #   
  #   describe 'Course#groups' do
  #     it 'is a an array'
  #     it 'can be empty'
  #     it 'contains Group objects'
  #   end
  # end
  # 
  # describe 'saving' do
  #   before(:each) do
  #     @connection.should_receive(:process).at_least(:once).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
  #     @saved_course = Course.find(1257981186)
  #     @unsaved_course = Course.new(:parent_handle => 1)
  #     @will_be_saved_course = Course.new(:parent_handle => 1)
  #   end
  #   
  #   it 'tells if you if it is unsaved' do
  #     @unsaved_course.saved?.should be_false
  #   end
  #   
  #   it 'tells if you if it has been saved' do
  #     @saved_course.saved?.should be_true
  #   end
  #   
  #   it 'can save'
  #   
  #   it 'can update' do
  #    lambda { @saved_course.update }.should_not raise_error
  #   end
  #   
  #   it 'can create if unsaved'
  #   
  #   it 'cannot create an already created coures'
  #   
  #   it 'calls update if saved?'
  #   
  #   it 'calls create if unsaved?'
  # end
# end