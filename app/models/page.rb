class Page < ActiveRecord::Base
  
  acts_as_nested_set :destroy_children => false
  
  validates_presence_of :title, :kind
  
  after_create :set_initial_parent
  before_create :ensure_root_exists
  
  has_many :assets, :dependent => :destroy, :order => 'created_at DESC'
  
  @@root_page_title = 'root'
  
  def self.reorder order_array, parent = nil
    parent ||= Page.root
    page = find(order_array[:id].to_i) if order_array[:id]
    page.move_to_child_of parent if page
    order_array.each do |key, value|
      reorder value, page unless key == "id"
    end
  end
  
private
  
  def ensure_root_exists
    if !self.class.root or (self.class.root and self.class.root.title != @@root_page_title)
      self.class.create({:title => @@root_page_title, :kind => 'category'}) unless self.title == @@root_page_title
    end
  end
  
  def set_initial_parent
    move_to_child_of self.class.root unless self.title == @@root_page_title
  end
  
end
