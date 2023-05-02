module NavbarHelper
  def nav_item(args = {})
    path = args[:path] || root_path
    active_controller_name = args[:active_controller_name] || 'main'
    controller_active = controller_name == active_controller_name

    icon_class = "text-warning bi bi-#{args[:icon_class]}" if args[:icon_class].present?
    icon_class.concat('-fill') if controller_active

    content_tag(:li, class: 'nav-item') do
      link_to(path, class: "nav-link #{'active' if controller_active}") do
        content_tag(:i, nil, class: icon_class)
      end
    end
  end
end
