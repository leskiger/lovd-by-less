module PagesHelper

  def page_kinds
    {"Content" => "content", "Link" => "link", "Category" => "category"}
  end
  
  def page_icon page
    case page.kind
    when "category":
      html = image_tag('icons/folder.png')
    when "content":
      html = image_tag('icons/page.png')
    when "link":
      html = image_tag('icons/link.png')
    end
    html
  end

  def menu_item_url page
    page.link_url ? page.link_url : page_path(page)
  end
  
  def page_crumb_trail page
    page.parents.map { |ancestor|
      page_crumb_trail_piece ancestor
    }.insert(0, link_to('Home', '/')).join " > "
  end
  
  def page_crumb_trail_piece page
    page.kind == "category" ? page.title : link_to(page.title, menu_item_url(page))
  end 

end
