class AboutView < View
  attr_reader :document

  def initialize(document:)
    @document = document
  end

  def content
    document.to_html
  end
end
