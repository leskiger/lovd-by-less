class Admin::PagesController < ApplicationController
  
  before_filter :setup
  
  def index
    @pages = Page.root.nil? ? Array.new : Page.root.full_tree

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end
  
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    post_response @page.save, :create
  end

  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
  
private

  def setup
    @page = params[:id] ? Page.find(params[:id]) : Page.new
    @page = Page.new
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
              page.visual_effect :fade, "no_pages_message"
              page << "$$('#new_page input[type=\"text\"]', '#new_forum textarea').each(function(input){input.value=''});"
            else
              page.replace_html @page.dom_id, :partial => 'page', :object => @page
              # page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            end
            # page << "tb_init('\##{@page.dom_id}_edit_link')"
            page << "tb_remove()"
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
