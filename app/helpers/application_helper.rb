module ApplicationHelper
  def current_controller?(names)
    names.include?(controller_name)
  end
end
