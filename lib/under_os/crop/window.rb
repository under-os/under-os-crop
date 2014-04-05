class UnderOs::Crop::Window < UnderOs::UI::View
  def initialize(options={})
    super class: 'window'

    append @bar_h1 = Bar.new('horizontal')
    append @bar_h2 = Bar.new('horizontal')

    append @bar_v1 = Bar.new('vertical')
    append @bar_v2 = Bar.new('vertical')
  end

  def expand(ratio)
    # expand the window to the ratio
  end

  class Bar < UnderOs::UI::View
    def initialize(orientation)
      super class: "bar #{orientation}"
    end
  end
end
