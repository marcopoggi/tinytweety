module ApplicationHelper
  def full_title(title = "")
    base_title = "TinyTweety"
    title = title.empty? ? base_title : "#{title} | #{base_title}"
  end
end
