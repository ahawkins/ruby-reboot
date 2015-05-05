class Processor
  include Concord.new(:data_store, :root)

  def landing_page(request)
    view = LandingPageView.new({
      screencast: data_store.highlighted_screencast,
      testimonials: data_store.shuffle_testimonals(take: 6)
    })

    Barcelona::Response.ok do |response|
      response.content_type = 'text/html'
      response.body = view.render
    end
  end

  def show_catalog(request)
    view = CatalogView.new({
      screencasts: data_store.screencasts
    })

    Barcelona::Response.ok do |response|
      response.content_type = 'text/html'
      response.body = view.render
    end
  end

  def show_screencast(request)
    view = ScreencastView.new({
      screencast: data_store.find_screencast(request.args.fetch(:id))
    })

    Barcelona::Response.ok do |response|
      response.content_type = 'text/html'
      response.body = view.render
    end
  end

  def show_about_page(request)
    view = AboutView.new({
      document: Kramdown::Document.new(File.read(root.join('pages', 'about.md')))
    })

    Barcelona::Response.ok do |response|
      response.html = view.render
    end
  end

  def show_contact_page(request)
    view = ContactView.new({
      document: Kramdown::Document.new(File.read(root.join('pages', 'contact.md')))
    })

    Barcelona::Response.ok do |response|
      response.html = view.render
    end
  end

  def show_unimplemented_page(request)
    Barcelona::Response.ok do |response|
      response.html = "<h1>Not Implemented Yet :(</h1>"
    end
  end
end
