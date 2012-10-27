module ApplicationHelper

  def pageless(total_pages, url=nil, container=nil)
    opts = {
      :totalPages => total_pages,
      :url        => url,
      :loaderMsg  => "Loading...",
      :loaderImage => image_path("load.gif")
    }
    
    container && opts[:container] ||= container
    
    javascript_tag("$('#{container}').pageless(#{opts.to_json});")
  end
  
  
  def link_with_selection(caption, parameters = {}, selection = {})
    link_to caption, parameters.merge(selection), :class => "#{'selected' if parameters[selection.keys.first] == selection.values.first.to_s}"
  end
  
  
end
