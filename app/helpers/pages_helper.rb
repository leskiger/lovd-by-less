module PagesHelper

  def page_kinds
    {"Content" => "content", "Link" => "link", "Category" => "category"}
  end
  
  def page_icon page
    case page.kind
    when "category":
      html = "(Cat)"
    when "content":
      html = "(Con)"
    when "link":
      html = "(Link)"
    end
    html
  end

end
