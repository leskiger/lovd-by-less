class Admin::AssetsController < ApplicationController
  
  before_filter :setup
  session :cookie_only => false, :only => :create

  def create
    if params[:asset] #html upload
      @asset = @page.assets.build(params[:asset])
      post_response @asset.save, :create
    elsif params[:Filedata] #swfupload
      @asset = @page.assets.create! :image => params[:Filedata]
      render :update do |page|
        page.insert_html :top, "#{@page.dom_id}_assets", :partial => "admin/assets/asset", :object => @asset
        page << "setupMarkItUpInsert('\##{@asset.dom_id} form.asset_insert_form input.insert_button');"
        page.visual_effect :highlight, @asset.dom_id
      end
    end
  end

  def update
    post_response @asset.update_attributes(params[:asset]), :update
  end

  def destroy
    @asset.destroy
    respond_to do |format|
      if @asset.destroy
        format.html { redirect_to(assets_url) }
        format.xml  { head :ok }
        format.js do
          render :update do |page|
            page.alert('look here')
            page.visual_effect :puff, @asset.dom_id, :complete => page.remove(@asset.dom_id)
          end
        end
      else
        format.html { redirect_to(assets_url) }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page|
            page.alert @asset.errors.to_s
          end
        end
      end
    end
  end
  
  def update_positions
    logger.info params[:assets_list].to_yaml
    Asset.reorder params[:assets_list]
    render :nothing => true
  end
  
private

  def setup
    @page = Page.find(params[:page_id])
    @asset = params[:id] ? Asset.find(params[:id]) : Asset.new
  end
  
  def post_response saved, action
    respond_to do |format|
      if saved
        format.html do 
          flash[:notice] = 'Asset was successfully saved.'
          redirect_to(edit_admin_page_path(@page)) 
        end
        
        format.xml  { render :xml => @asset, :status => (action == :create ? :created : :updated), :location => assets_path(@asset) }
        
        format.js do
          render :update do |page|
            if action == :create
              page.insert_html :bottom, :assets_list, :partial => 'asset', :object => @asset
              page.visual_effect :fade, "no_assets_note"
              page << "$$('#new_asset input[type=\"text\"]', '#new_forum textarea').each(function(input){input.value=''});"
              page << "Sortable.destroy('assets_list');"
              page << "Sortable.create(\"assets_list\", {dropOnEmpty:true, onUpdate:function(){new Ajax.Request('/admin/assets/update_positions', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize(\"assets_list\")})}, tree:true})"
            else
              page.replace_html @asset.dom_id, :partial => 'asset', :object => @asset
              # asset << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            end
            # asset << "tb_init('\##{@asset.dom_id}_edit_link');"
            # asset << "jQuery(\".markitup\").markItUp(mySettings);"
            # asset << "tb_remove();"
            page.visual_effect :highlight, @asset.dom_id
          end
        end
        
      else
        format.html { render :action => action == :create ? "new" : "edit" }
        
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
        
        format.js do
          render :update do |page|
            page.alert @asset.errors.to_s
          end
        end
      end
    end
  end
  
  def allow_to
    super :admin, :all => true
  end
  
end
