require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  
  include PagesTestHelper
  
  should "NOT get the index as guest" do
    assert_nothing_raised do
      get :index, {}
      assert_response 302
      assert_redirected_to :login_path
    end
  end
  
  should "NOT get the index as :user" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end

  should "get the index as :admin" do
    assert_nothing_raised do
      get :index, {}, {:user => profiles(:admin).id}
      assert_response 200
      assert_template 'index'
      assert_tag :tag => 'a', :content => "Create a new page"
      pages.each do |page|
       
      end
    end
  end
  
  should "NOT create a new page for guest" do
    assert_no_difference "Page.count" do
      post :create, {:page => valid_page_attributes}
      assert_response 302
      assert_redirected_to :login_path
    end
  end
  
  should "NOT create a new page for :user" do
    assert_no_difference "Page.count" do
      post :create, {:page => valid_page_attributes}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end
  
  should "create a new page for :admin (HTML)" do
    assert_difference "Page.count" do
      post :create, {:page => valid_page_attributes}, {:user => profiles(:admin).id}
      assert_response 302
      assert flash[:error].nil?
    end
  end
  
end
