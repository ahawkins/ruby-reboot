class ScreencastView < View
  extend Forwardable

  attr_reader :screencast

  def_delegators :screencast, :title, :summary, :duration, :preview

  attr_reader :date

  def initialize(screencast:)
    @screencast = screencast
    @date = screencast.date.strftime "%Y-%m-%d"
  end
end
