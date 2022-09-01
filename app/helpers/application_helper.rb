module ApplicationHelper
  def full_title(title = "")
    base_title = "TiniTweety"
    title = title.empty? ? base_title : "#{title} | #{base_title}"
  end
end
