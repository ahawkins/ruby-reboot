require 'bundler/setup'
require 'pathname'
require 'concord'
require 'barcelona'
require 'mustache'
require 'anima'
require 'rom'
require 'inflecto'
require 'securerandom'
require 'kramdown'

root = Pathname.new __dir__

$LOAD_PATH.unshift root.join('lib')
$LOAD_PATH.unshift root.join('src')

Duration = Struct.new :minutes do
  def hours
    minutes / 60
  end

  def remainder
    minutes % 60
  end

  def to_s
    "%2i:%02i:00" % [ hours, remainder ]
  end
end

class Testimonial
  include Anima.new(:text, :twitter)
end

class Screencast
  include Anima.new(:id, :title, :minutes, :summary, :date, :preview)

  def duration
    Duration.new minutes
  end
end

class DataStore
  ROM.setup :memory

  class Testimonials < ROM::Relation[:memory]
    register_as :testimonials
  end

  class TestimonalMapper < ROM::Mapper
    relation :testimonials

    register_as :entity

    model Testimonial

    attribute :text
    attribute :twitter
  end

  class AddTestimonal < ROM::Commands::Create[:memory]
    register_as :add
    relation :testimonials
    result :one
  end

  class ClearTestimonals < ROM::Commands::Delete[:memory]
    register_as :clear
    relation :testimonials
    result :many
  end

  class Screencasts < ROM::Relation[:memory]
    register_as :screencasts

    def with_id(id)
      restrict id: id
    end
  end

  class ScreencastMapper < ROM::Mapper
    relation :screencasts

    register_as :entity

    model Screencast

    attribute :id
    attribute :title
    attribute :minutes
    attribute :summary
    attribute :date
    attribute :preview
  end

  class CreateScreencast < ROM::Commands::Create[:memory]
    register_as :create
    relation :screencasts
    result :one

    def call(data)
      super(({
        id: Digest::SHA1.hexdigest(data.fetch(:title))
      }).merge(data))
    end
  end

  class ClearScreencasts < ROM::Commands::Delete[:memory]
    register_as :clear
    relation :screencasts
    result :many
  end

  include Concord.new(:rom)

  def clear
    rom.command(:screencasts).clear.call
    rom.command(:testimonials).clear.call
  end

  def screencasts
    rom.relation(:screencasts).as(:entity).to_a
  end

  def create_screencast(data)
    rom.command(:screencasts).create.call data
  end

  def find_screencast(id)
    rom.relation(:screencasts).with_id(id).as(:entity).one!
  end

  def add_testimonal(data)
    rom.command(:testimonials).add.call data
  end

  def shuffle_testimonals(take:)
    rom.relation(:testimonials).as(:entity).to_a.shuffle.take(take)
  end

  def highlighted_screencast
    rom.relation(:screencasts).as(:entity).to_a.shuffle.first
  end
end

class View < Mustache
  self.template_path = File.join __dir__, 'src', 'templates'
end

require 'views/landing_page_view'
require 'views/catalog_view'
require 'views/screencast_view'
require 'views/about_view'
require 'views/contact_view'

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

SystemManager = Struct.new :processor, :app, :data, :root do
  def clear
    data.clear
  end

  def seed
    clear
    30.times do |i|
      data.create_screencast({
        title: "Dev Sceencast #{i+1}",
        minutes: rand(5..90),
        summary: (%w(Lorem ipsum dolor sit amet.) * 30).join(' '),
        date: Time.now - (rand(0..(60 * 60 * 24 * 7))),
        preview: 'https://www.youtube.com/embed/asLUTiJJqdE'
      })
    end
    15.times do |i|
      data.add_testimonal({
        text: (%w(Lorem ipsum dolor sit amet.) * 2).join(' '),
        twitter: 'someone'
      })
    end
  end
end

SYSTEM = SystemManager.new.tap do |system|
  system.root = root

  system.data = DataStore.new ROM.finalize.env

  system.processor = Processor.new system.data, system.root

  system.app = Barcelona::Mapper.new system.processor do |http|
    http.get '/', :landing_page
    http.get '/catalog', :show_catalog
    http.get '/screencast/:id', :show_screencast
    http.get '/about', :show_about_page
    http.get '/contact', :show_contact_page

    http.static '/public', system.root.join('public')

    # Placeholders
    http.get '/sign_up', :show_unimplemented_page
    http.get '/screencast/:id/download', :show_unimplemented_page
  end

  system.freeze
end
