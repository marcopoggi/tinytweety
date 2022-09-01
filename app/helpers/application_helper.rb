module ApplicationHelper
  def full_title(title = "")
    base_title = "Tinitweety"
    title = title.empty? ? base_title : "#{title} | #{base_title}"
  end
end
