require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  
  include PagesTestHelper
  
  should "set initial parent to root for a new page" do
    page = Page.create(valid_page_attributes)
    assert_equal Page.root, page.parent
  end
  
  should "not destroy if page has children" do
    page = Page.create(valid_page_attributes)
    child = Page.create(valid_page_attributes)
    child.move_to_child_of page
    assert_no_difference "Page.count" do
      page.destroy
      assert !page.errors.empty?
    end
  end
  
end
