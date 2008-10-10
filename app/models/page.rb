class Page < ActiveRecord::Base
  
  acts_as_nested_set :destroy_children => false
  
  has_permalink :permalink_titles, {:create_on_update => true}
  
  validates_presence_of :title, :kind
  
  after_create :set_initial_parent
  before_create :ensure_root_exists
  
  has_many :assets, :dependent => :destroy, :order => 'created_at DESC'
  
  @@root_page_title = 'root'
  
  def to_param
    permalink
  end
  
  def self.reorder order_array, parent = nil
    parent ||= Page.root
    page = find(order_array[:id].to_i) if order_array[:id]
    page.move_to_child_of parent if page
    order_array.each do |key, value|
      reorder value, page unless key == "id"
    end
  end
  
  ##
  # title with parent titles
  def full_title
    parents.map { |parent| parent.title }.push(title).join(" - ")
  end
  
  ##
  # return the ancestors w/out the root node
  def parents
    ancestors.reject { |a| a.is_root?}
  end
  
  def is_root?
    title == @@root_page_title
  end
  
private
  
  def permalink_titles
    titles = title
    titles = self_and_ancestors.collect { |ancestor| ancestor.title+"-" unless ancestor.is_root? } if id
    titles
  end
  
  def ensure_root_exists
    if !self.class.root or (self.class.root and self.class.root.title != @@root_page_title)
      self.class.create({:title => @@root_page_title, :kind => 'category'}) unless self.is_root?
    end
  end
  
  def set_initial_parent
    move_to_child_of self.class.root unless self.is_root?
  end
  
end
