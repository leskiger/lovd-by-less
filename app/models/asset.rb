# == Schema Information
# Schema version: 1
#
# Table name: photos
#
#  id         :integer(11)   not null, primary key
#  caption    :string(1000)  
#  created_at :datetime      
#  updated_at :datetime      
#  profile_id :integer(11)   
#  image      :string(255)   
#


class Asset < ActiveRecord::Base
  
  belongs_to :page
  
  validates_presence_of :image, :page_id

  file_column :image, :magick => {
    :versions => { 
      :square => {:crop => "1:1", :size => "150x150", :name => "square"},
      :small => "250x250>"
    }
  }
    
end
