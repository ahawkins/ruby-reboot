class DataStore
  ROM.setup :memory

  class Testimonials < ROM::Relation[:memory]
    register_as :testimonials
  end

  class TestimonalMapper < ROM::Mapper
    relation :testimonials

    register_as :entity

    model Testimonial

    attribute :text
    attribute :twitter
  end

  class AddTestimonal < ROM::Commands::Create[:memory]
    register_as :add
    relation :testimonials
    result :one
  end

  class ClearTestimonals < ROM::Commands::Delete[:memory]
    register_as :clear
    relation :testimonials
    result :many
  end

  class Screencasts < ROM::Relation[:memory]
    register_as :screencasts

    def with_id(id)
      restrict id: id
    end
  end

  class ScreencastMapper < ROM::Mapper
    relation :screencasts

    register_as :entity

    model Screencast

    attribute :id
    attribute :title
    attribute :minutes
    attribute :summary
    attribute :date
    attribute :preview
  end

  class CreateScreencast < ROM::Commands::Create[:memory]
    register_as :create
    relation :screencasts
    result :one

    def call(data)
      super(({
        id: Digest::SHA1.hexdigest(data.fetch(:title))
      }).merge(data))
    end
  end

  class ClearScreencasts < ROM::Commands::Delete[:memory]
    register_as :clear
    relation :screencasts
    result :many
  end

  include Concord.new(:rom)

  def clear
    rom.command(:screencasts).clear.call
    rom.command(:testimonials).clear.call
  end

  def screencasts
    rom.relation(:screencasts).as(:entity).to_a
  end

  def create_screencast(data)
    rom.command(:screencasts).create.call data
  end

  def find_screencast(id)
    rom.relation(:screencasts).with_id(id).as(:entity).one!
  end

  def add_testimonal(data)
    rom.command(:testimonials).add.call data
  end

  def shuffle_testimonals(take:)
    rom.relation(:testimonials).as(:entity).to_a.shuffle.take(take)
  end

  def highlighted_screencast
    rom.relation(:screencasts).as(:entity).to_a.shuffle.first
  end
end
