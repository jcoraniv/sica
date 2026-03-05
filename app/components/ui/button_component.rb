module Ui
  class ButtonComponent < ViewComponent::Base
    def initialize(text:, href: nil, variant: :primary, type: :button)
      @text = text
      @href = href
      @variant = variant
      @type = type
    end

    attr_reader :text, :href, :variant, :type

    def classes
      tone = case variant.to_sym
             when :secondary
               "secondary-button"
             when :danger
               "danger-button"
             else
               "primary-button"
             end
      tone
    end
  end
end
