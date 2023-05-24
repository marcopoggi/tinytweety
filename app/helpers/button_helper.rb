module ButtonHelper
  def custom_button(args = {})
    content = args[:content] || ''
    path = args[:path] || '#'
    button_class = args[:button_class] || 'btn'

    link_to(path, class: button_class) do
      content_tag(:span, content)
    end
  end
end
