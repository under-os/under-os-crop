class UnderOs::Crop::Window < UnderOs::UI::View
  def initialize(options={})
    super class: 'window'

    @_.userInteractionEnabled = false

    append @over_1 = Overlay.new
    append @over_2 = Overlay.new

    append @bar_h1 = Bar.new('horizontal')
    append @bar_h2 = Bar.new('horizontal')

    append @bar_v1 = Bar.new('vertical')
    append @bar_v2 = Bar.new('vertical')
  end

  def expand(ratio)
    parent_size  = parent.size
    parent_ratio = parent_size.x / parent_size.y
    ratio      ||= parent_ratio
    new_size     = {x: parent_size.x, y: parent_size.y}

    if ratio > parent_ratio
      new_size[:y] = parent_size.x / ratio
    else
      new_size[:x] = parent_size.y * ratio
    end

    self.size = {x: new_size[:x] + 2, y: new_size[:y] + 2}
  end

  def size=(new_size)
    super new_size

    self.position = {
      x: parent.size.x / 2 - size.x / 2,
      y: parent.size.y / 2 - size.y / 2
    }

    move_bars
    move_overlays
  end

  def move_bars
    @bar_h1.position.y = size.y / 3
    @bar_h2.position.y = size.y / 3 * 2
    @bar_v1.position.x = size.x / 3
    @bar_v2.position.x = size.x / 3 * 2

    @bar_h1.size.x = size.x
    @bar_h2.size.x = size.x
    @bar_v1.size.y = size.y
    @bar_v2.size.y = size.y
  end

  def move_overlays
    if position.x > position.y # vertical
      @over_1.style = {width: position.x, height: size.y, top: 0, left:  -position.x}
      @over_2.style = {width: position.x, height: size.y, top: 0, right: -position.x}
    else # horizontal
      @over_1.style = {width: size.x, height: position.y, left: 0, top:    -position.y}
      @over_2.style = {width: size.x, height: position.y, left: 0, bottom: -position.y}
    end
  end

  class Bar < UnderOs::UI::View
    def initialize(orientation)
      super class: "bar #{orientation}"
    end
  end

  class Overlay < UnderOs::UI::View
    def initialize(options={})
      super class: 'overlay'
    end
  end
end
