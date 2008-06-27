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
  
  should "NOT create a new page for :user (HTML)" do
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
  
  should "create a new page for :admin (JS)" do
    assert_difference "Page.count" do
      post :create, {:page => valid_page_attributes, :format => 'js'}, {:user => profiles(:admin).id}
      assert_response :success
      assert_select_rjs :insert, :bottom
    end
  end
  
  should "NOT update a page for guest" do
    put :update, {:id => pages(:content_page).id, :page => valid_page_attributes}
    assert_response 302
    assert_redirected_to :login_path
  end
  
  should "NOT update a new page for :user (HTML)" do
    put :update, {:id => pages(:content_page).id, :page => valid_page_attributes}, {:user => profiles(:user).id}
    assert_response 302
    assert flash[:error]
  end
  
  should "update a new page for :admin (HTML)" do
    put :update, {:id => pages(:content_page).id, :page => valid_page_attributes}, {:user => profiles(:admin).id}
    assert_redirected_to admin_pages_path
    assert flash[:error].nil?
  end
  
  should "update a new page for :admin (JS)" do
    put :update, {:id => pages(:content_page).id, :page => valid_page_attributes, :format => 'js'}, 
                  {:user => profiles(:admin).id}
    assert_response :success
    assert_select_rjs :replace_html
  end
  
  should "NOT destroy a page for guest" do
    assert_no_difference "Page.count" do
      delete :destroy, {:id => pages(:content_page).id}
      assert_response 302
      assert_redirected_to :login_path
    end
  end
  
  should "NOT destroy a page for :user (HTML)" do
    assert_no_difference "Page.count" do
      delete :destroy, {:id => pages(:content_page).id}, {:user => profiles(:user).id}
      assert_response 302
      assert flash[:error]
    end
  end
  
  should "destroy a page for :admin (HTML)" do
    page = Page.create(valid_page_attributes)
    page.renumber_full_tree
    delete :destroy, {:id => page.id}, {:user => profiles(:admin).id}
    assert_response 302
    assert flash[:error].nil?
  end
  
  should "destroy a page for :admin (JS)" do
    page = Page.create(valid_page_attributes)
    page.renumber_full_tree
    delete :destroy, {:id => page.id, :format => 'js'}, {:user => profiles(:admin).id}
    assert_response :success
  end
  
end
