require File.dirname(__FILE__) + '/../spec_helper'

module CategorySpecHelper

  def valid_category_attributes
    {
      :name => 'test_category_name'
    }
  end
  
end

describe Category do
  
  include CategorySpecHelper
  
  before(:each) do
    @category = Category.new
    @category.attributes = valid_category_attributes
  end
  
  it "should be valid" do
    @category.should be_valid
  end
  
  it "should require name" do
    @category.name = nil
    @category.should have(1).error_on(:name)
  end
  
  it "should require a unique name" do
    @category.save
    @category2 = Category.new
    @category2.attributes = valid_category_attributes
    @category2.should have(1).error_on(:name)
  end
  
  it "should create a permalink from a name before_validation" do
    @category.valid?
    @category.permalink.should == (@category.name.downcase.gsub(/[^[:alnum:]]/,'-')).gsub(/-{2,}/,'-')
  end
  
  it "should have vectors" do
    lambda { @category.vectors }.should_not raise_error(NoMethodError) 
  end
  
end 

describe Category, ".to_param" do
  
  include CategorySpecHelper
  
  it "should return id-permalink" do
    @category = Category.new
    @category.attributes = valid_category_attributes
    @category.id = 1
    @category.valid?
    @category.to_param.should == "#{@category.id}-#{@category.permalink}"
  end

end