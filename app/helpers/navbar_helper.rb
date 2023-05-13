module NavbarHelper
  def nav_item(path: root_path, controller_target: 'main', icon: 'app')
    active = controller_name == controller_target

    content_tag(:li, class: 'nav-item') do
      link_to(path, class: active ? 'nav-link active' : 'nav-link', data: tooltip_data(controller_target:)) do
        content_tag(:i, nil, class: "nav-icon text-warning bi bi-#{icon_class(active:, icon:, controller_target:)}")
      end
    end
  end

  private

  # custom icon class
  def icon_class(active: false, icon: 'app', controller_target: 'main')
    return icon unless active

    controller_name_active_classes = {
      main: '-fill',
      messages: '-fill',
      notifications: '-fill',
      search: ' custom--icon-search-fill'
    }

    "#{icon}#{controller_name_active_classes[controller_target.to_sym]}"
  end

  # custom tooltip title
  def tooltip_data(controller_target: 'main')
    controller_name_tooltip_titles = {
      main: 'Home',
      messages: 'Messages',
      notifications: 'Notifications',
      search: 'Explore'
    }

    title = controller_name_tooltip_titles[controller_target.to_sym]

    {
      bs_toggle: 'tooltip',
      bs_placement: 'top',
      bs_title: title,
      bs_custom_class: 'custom--navbar-tooltip',
      bs_boundary: 'window'
    }
  end
end
