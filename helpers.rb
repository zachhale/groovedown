module Groovedown
  module Helpers
    # TODO: escape params
    def link_to(name, url, params={})
      url << "?#{params.map{|k,v|"#{k}=#{v}"}.join("&")}" unless params.empty?
      %Q(<a href="#{url}">#{name}</a>)
    end
  end
end