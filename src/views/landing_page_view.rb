class LandingPageView < View
  attr_reader :screencast, :testimonials

  def initialize(screencast: nil, testimonials: [ ])
    @screencast = screencast
    @testimonials = testimonials
  end

  def testimonal_grid
    testimonials.each_slice(2)
  end

  def preview
    screencast.preview
  end
end
