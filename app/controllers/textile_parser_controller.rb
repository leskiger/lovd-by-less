class TextileParserController < ApplicationController
  
  skip_filter :login_required, :only => [:parse]
  
  def parse
    @data = params[:data]
  end
  
  private
  
  def allow_to
    super :all, :only => [:parse]
  end
  
end
