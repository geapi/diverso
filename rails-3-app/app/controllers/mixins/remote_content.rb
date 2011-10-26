module Mixins::RemoteContent

  protected

  # Renders the partials passed to it, with a content-type of text/html so jquery parses the response correctly
  #
  # Examples:
  #
  #   render_remote_content("shared/sidebar")
  #     # => render_to_string(:partial => "shared/sidebar")
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  #   render_remote_content("shared/sidebar" => {:item => :admin})
  #     # => render_to_string(:partial => "shared/sidebar", :locals => {:item => :admin})
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  #   render_remote_content("shared/navigation", "shared/sidebar" => {:item => :admin})
  #     # => render_to_string(:partial => "shared/navigation")
  #     # => render_to_string(:partial => "shared/sidebar", :locals => {:item => :admin})
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  def render_remote_content(*partials)
    headers["Content-Type"] = "text/html; charset=utf-8"
    render :text => response_html_from_partials(*partials)
  end

  # Renders the partials passed to it in the iframe layout, designed to respond to async file uploads
  #
  # Examples:
  #
  #   render_iframe_content("shared/sidebar")
  #     # => render_to_string(:partial => "shared/sidebar")
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  #   render_iframe_content("shared/sidebar" => {:item => :admin})
  #     # => render_to_string(:partial => "shared/sidebar", :locals => {:item => :admin})
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  #   render_iframe_content("shared/navigation", "shared/sidebar" => {:item => :admin})
  #     # => render_to_string(:partial => "shared/navigation")
  #     # => render_to_string(:partial => "shared/sidebar", :locals => {:item => :admin})
  #     # => render_to_string(:partial => "layouts/flash_content")
  #
  def render_iframe_content(*partials)
    render :text => response_html_from_partials(*partials), :layout => "iframe_response"
  end

  private

  def response_html_from_partials(*partials)
    partials_with_locals = partials.extract_options!
    html = []
    html += partials.map { |partial| render_to_string(:partial => partial) }
    html += partials_with_locals.map { |partial, locals| render_to_string(:partial => partial, :locals => locals) }
    html << render_to_string(:partial => "layouts/flash_content")
    html.join
  end

end