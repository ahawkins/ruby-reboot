class Screencast
  include Anima.new(:id, :title, :minutes, :summary, :date, :preview)

  def duration
    Duration.new minutes
  end
end
