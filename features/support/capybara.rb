require 'capybara'

After do
  Capybara.reset_sessions!
end

Before do
  Capybara.use_default_driver
end

Before '@javascript' do
  Capybara.current_driver = Capybara.javascript_driver
end

Before do |scenario|
  scenario.source_tag_names.each do |tag|
    driver_name = tag.sub(/^@/, '').to_sym
    if Capybara.drivers.has_key?(driver_name)
      Capybara.current_driver = driver_name
    end
  end
end

module GUIHelpers
  attr_reader :gui
end

World GUIHelpers

Before do
  @gui = GUITester.new Capybara.current_session
end

Capybara.app = SYSTEM.app
