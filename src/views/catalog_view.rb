class CatalogView < View
  class Presenter < DelegateClass(Screencast)
    def date
      super.strftime "%Y-%m-%d"
    end
  end

  attr_reader :screencasts

  def initialize(screencasts: [ ])
    @screencasts = screencasts.map do |item|
      Presenter.new item
    end
  end
end
