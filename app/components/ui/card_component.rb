module Ui
  class CardComponent < ViewComponent::Base
    renders_one :actions

    def initialize(title: nil, subtitle: nil, compact: false)
      @title = title
      @subtitle = subtitle
      @compact = compact
    end

    attr_reader :title, :subtitle, :compact
  end
end
