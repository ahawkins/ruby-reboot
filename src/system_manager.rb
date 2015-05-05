SystemManager = Struct.new :processor, :app, :data, :root do
  def clear
    data.clear
  end

  def seed
    clear
    30.times do |i|
      data.create_screencast({
        title: "Dev Sceencast #{i+1}",
        minutes: rand(5..90),
        summary: (%w(Lorem ipsum dolor sit amet.) * 30).join(' '),
        date: Time.now - (rand(0..(60 * 60 * 24 * 7))),
        preview: 'https://www.youtube.com/embed/asLUTiJJqdE'
      })
    end
    15.times do |i|
      data.add_testimonal({
        text: (%w(Lorem ipsum dolor sit amet.) * 2).join(' '),
        twitter: 'someone'
      })
    end
  end
end
