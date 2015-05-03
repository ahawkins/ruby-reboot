Before do
  @focused_title = nil
end

Given(/^the site is launched$/) do
  sys.seed
end

When(/^I go to the landing page$/) do
  gui.open_landing_page
end

Then(/^I should see a big sign up button$/) do
  assert_equal '/sign_up', gui.cita, 'Call to action incorrect'
end

Then(/^I should get a preview$/) do
  assert gui.marketing_preview_video?, 'No preview video'
end

Then(/^there should be a link to all screencasts$/) do
  assert gui.catalog_button?, 'No catalog button'
end

Then(/^I should see testimonials to convince me$/) do
  assert gui.testimonials?, 'No testimonials'
end

Given(/^there's a "([^"]*)" screencast$/) do |title|
  sys.data.create_screencast({
    title: title,
    minutes: 100,
    summary: 'In depth summary......',
    preview: 'www.example.com/foo.mp4',
    date: Time.now
  })
end

Then(/^the "([^"]*)" screencast should be shown$/) do |title|
  assert gui.says?(title), 'Screencast not displayed'
  @focused_title = title
end

When(/^I click the catalog link$/) do
  gui.click_catalog_link
end

Then(/^the length should be shown$/) do
  assert @focused_title, 'No focused GUI item'

  assert gui.length_for(@focused_title), 'Length missing'
end

Then(/^the date should be shown$/) do
  assert @focused_title, 'No focused GUI item'

  assert gui.date_for(@focused_title), 'Date missing'
end

Then(/^the summary should be printed$/) do
  assert @focused_title, 'No focused GUI item'

  assert gui.summary_for(@focused_title), 'Summary missing'
end

When(/^I click on the "([^"]*)" screencast$/) do |title|
  gui.click_screencast title
end

Then(/^a download link should be shown$/) do
  assert @focused_title, 'No focused GUI item'

  assert gui.download_url_for(@focused_title), 'No download link'
end

Then(/^the preview should play$/) do
  assert @focused_title, 'No focused GUI item'

  assert gui.preview_video?(@focused_title), 'No video preview'
end
