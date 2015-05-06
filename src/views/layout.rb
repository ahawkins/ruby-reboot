class Layout < Mustache
  self.template_path = File.join __dir__, 'src', 'templates'

  def initialize(delegate)
    super()
    @context = Mustache::Context.new delegate
  end
end
