class View < Mustache
  def year
    Time.now.year
  end

  def render
    Layout.new(self).render yield: super
  end
end
