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
