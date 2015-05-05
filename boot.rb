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

require 'duration'
require 'screencast'
require 'testimonial'
require 'data_store'
require 'processor'
require 'system_manager'

class View < Mustache
  self.template_path = File.join __dir__, 'src', 'templates'
end

require 'views/landing_page_view'
require 'views/catalog_view'
require 'views/screencast_view'
require 'views/about_view'
require 'views/contact_view'

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
