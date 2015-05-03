require 'shotgun'

# Create custom Shotgun loader that does not require a config.ru
# or do anything else to determine the underlying rack
# application. The class requires a block at instantiation time.
# The block is executed in a separate process to create the rack
# application.
class Reloader < Shotgun::Loader
  def initialize(&builder)
    fail ArgumentError, 'No builder given' unless builder
    @builder = builder
  end

  def assemble_app
    rack = Rack::Builder.new
    rack.use Rack::ShowExceptions

    @builder.call rack

    rack.to_app
  end
end
