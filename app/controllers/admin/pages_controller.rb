class Admin::PagesController < ApplicationController
  
  before_filter :setup
  
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @root_pages }
    end
  end

  def create
    @page = Page.new(params[:page])
    post_response @page.save, :create
  end
  
  def edit
    @asset = Asset.new
  end

  def update
    post_response @page.update_attributes(params[:page]), :update
  end

  def destroy
    @page.destroy
    respond_to do |format|
      if @page.destroy
        format.html { redirect_to(pages_url) }
        format.xml  { head :ok }
        format.js do
          render :update do |page|
            page.visual_effect :puff, @page.dom_id
          end
        end
      else
        format.html { redirect_to(pages_url) }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page|
            page.alert @page.errors.to_s
          end
        end
      end
    end
  end
  
  def update_positions
    Page.reorder params[:pages_list]
    render :nothing => true
  end
  
private

  def setup
    if params[:id].to_i != 0
      @page = Page.find(params[:id])
    elsif params[:id]
      @page = Page.find_by_permalink(params[:id])
    else
      @page = Page.new
    end
  end
  
  def post_response saved, action
    respond_to do |format|
      if saved
        format.html do 
          flash[:notice] = 'Page was successfully saved.'
          redirect_to(admin_pages_path) 
        end
        
        format.xml  { render :xml => @page, :status => (action == :create ? :created : :updated), :location => pages_path(@page) }
        
        format.js do
          render :update do |page|
            if action == :create
              page.insert_html :bottom, :pages_list, :partial => 'page', :object => @page
              page.visual_effect :fade, "no_pages_note"
              page << "$$('#new_page input[type=\"text\"]', '#new_forum textarea').each(function(input){input.value=''});"
              page << "Sortable.destroy('pages_list');"
              page << "Sortable.create(\"pages_list\", {dropOnEmpty:true, onUpdate:function(){new Ajax.Request('/admin/pages/update_positions', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize(\"pages_list\")})}, tree:true})"
            else
              page.replace_html @page.dom_id, :partial => 'page', :object => @page
              page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            end
            page << "tb_init('\##{@page.dom_id}_edit_link');"
            page << "jQuery(\".markitup\").markItUp(mySettings);"
            page << "tb_remove();"
            page.visual_effect :highlight, @page.dom_id
          end
        end
        
      else
        format.html { render :action => action == :create ? "new" : "edit" }
        
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        
        format.js do
          render :update do |page|
            page.alert @page.errors.to_s
          end
        end
      end
    end
  end
  
  def allow_to
    super :admin, :all => true
  end
  
end
