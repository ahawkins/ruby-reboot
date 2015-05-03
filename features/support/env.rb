root = File.expand_path "../../..", __FILE__
require "#{root}/boot"

require_relative 'assertions'
require_relative 'gui_tester'
require_relative 'system'
require_relative 'capybara'

require_relative 'system_hooks'

# Load all step definitions
Dir[File.join(root, 'features', 'step_definitions', '**', '*.rb')].each do |file|
  require file
end
