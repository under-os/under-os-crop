class UnderOs::Crop < UnderOs::UI::View
class Scroll < UOS::UI::Scroll
  attr_reader :image

  def initialize(options={})
    super options

    UnderOs::App.history.current_page._.automaticallyAdjustsScrollViewInsets = false

    self.minScale = 1.0
    self.maxScale = 3.0
    @_.decelerationRate = 0.2

    append @image = UOS::UI::Image.new

    self.zoomItem = @image
    self.on(:zoom) { centerContent }
  end

  def image=(src)
    @image.src = src
    self.scale = 1.0 and @resetting = nil if @resetting

    scale      = [self.size.x / src.size.width, self.size.y / src.size.height].min
    @new_size  = {x: src.size.width * scale * self.scale, y: src.size.height * scale * self.scale}

    @image.size      = @new_size
    self.contentSize = @new_size

    centerContent
  end

  def resetting!
    @resetting = true
  end
end
end
