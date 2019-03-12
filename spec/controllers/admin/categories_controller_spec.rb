require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before(:each) do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  it "test_index" do
    get :index
    assert_response :redirect, :action => 'index'
  end

  describe "test_edit" do
    before(:each) do
      get :edit, :id => Factory(:category).id
    end

    it 'should render template new' do
      assert_template 'new'
      assert_tag :tag => "table",
        :attributes => { :id => "category_container" }
    end

    it 'should have valid category' do
      assigns(:category).should_not be_nil
      assert assigns(:category).valid?
      assigns(:categories).should_not be_nil
    end
  end

# Start of new rspec test cases
# New Rspec Test for create 
  it "test_create" do
    post :new, :category => { name: 'new category test', keywords: 'test', permalink: 'test', description: 'test' }
    assert_response :redirect, :action => 'index'
    new_category = Category.find_by_name("new category test")
    assert_not_nil new_category
  end

# New Rspec test to edit an existing category 
  it 'should edit an existing category' do
     post :edit, :category =>{:name => "new category test", :keywords => "test", :permalink => "test", :description => "test"}
    assert_response :redirect, :action => "index"
    assert_not_nil assigns(:category)
    expect(flash[:notice]).to eq("Category was successfully saved.")
  end

# End of new rspec tests

  it "test_update" do
    post :edit, :id => Factory(:category).id
    assert_response :redirect, :action => 'index'
  end

  describe "test_destroy with GET" do
    before(:each) do
      test_id = Factory(:category).id
      assert_not_nil Category.find(test_id)
      get :destroy, :id => test_id
    end

    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'      
    end
  end

  it "test_destroy with POST" do
    test_id = Factory(:category).id
    assert_not_nil Category.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end
  
end