class Page < ActiveRecord::Base
  
  acts_as_nested_set
  
  validates_presence_of :title
  
  @@root_page_title = 'root'
  
  after_create :set_initial_parent
  before_create :ensure_root_exists
  
  alias_method :old_before_destroy, :before_destroy
  
  def before_destroy
    logger.info "*** start of before_destroy"
    if !children.empty?
      logger.info "*** should not destroy, has children"
      errors.add_to_base "You cannnot destroy a page that has children."
      return false
    else
      logger.info "*** about to call old_before_destroy"
      return old_before_destroy
      logger.info "*** end of before_destroy"
    end
  end
  
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
  
  def check_for_children
    unless children.empty?
      errors.add_to_base "You cannnot destroy a page that has children."
      return false
    end
  end
  
end
