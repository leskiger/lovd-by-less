class PagesController < ApplicationController
  
  before_filter :setup
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end
  
protected
  def setup
    set_page
    set_title
  end
  
  def set_page
    if params[:id].to_i != 0
      @page = Page.find(params[:id])
    elsif params[:id]
      @page = Page.find_by_permalink(params[:id])
    else
      @page = Page.new
    end
  end
  
  def set_title
    @title = "#{SITE_NAME} - #{@page.full_title}"
  end
end
