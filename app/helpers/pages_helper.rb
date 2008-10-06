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

end
