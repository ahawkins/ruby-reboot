require 'forwardable'

class GUITester
  extend Forwardable

  include Concord.new(:driver)

  def open_landing_page
    driver.visit '/'
  end

  def click_catalog_link
    driver.click_on 'Catalog'
  end

  def click_about_link
    driver.click_on 'About'
  end

  def click_contact_link
    driver.click_on 'Contact'
  end

  def click_screencast(title)
    driver.click_on title
  end

  def html?(html)
    driver.body.include? html
  end

  def says?(text)
    driver.has_content? text
  end

  def cita
    driver.find(:css, "#cita")[:href]
  end

  def testimonials?
    driver.all(:css, ".testimonial").any?
  end

  def catalog_button?
    driver.all(:css, "a.catalog.btn").any?
  end

  def active_link
    if driver.has_selector? "nav li.active"
      driver.find(:css, "nav li.active").text.downcase.to_sym
    else
      nil
    end
  end

  def length_for(title)
    container = driver.find :css, %Q{[data-screencast="#{title}"]}
    text = container.find(:css, '.length').text
    text.empty? ? nil : text
  end

  def date_for(title)
    container = driver.find :css, %Q{[data-screencast="#{title}"]}
    text = container.find(:css, '.date').text
    text.empty? ? nil : text
  end

  def summary_for(title)
    container = driver.find :css, %Q{[data-screencast="#{title}"]}
    text = container.find(:css, '.summary').text
    text.empty? ? nil : text
  end

  def download_url_for(title)
    container = driver.find :css, %Q{[data-screencast="#{title}"]}
    href = container.find(:css, '.download')[:href]
    href.empty? ? nil : href
  end

  def preview_video?(title)
    driver.has_selector? :css, %Q{[data-screencast="#{title}"] .preview}
  end

  def marketing_preview_video?
    driver.has_selector? :css, '.marketing-preview'
  end

  def to_s
    driver.body.to_s
  end
end
