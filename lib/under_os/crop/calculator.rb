class UnderOs::Crop::Calculator
  attr_reader :angle, :rectangle

  def initialize(image_view)
    @frame = image_view.size
    @image = image_view.src.size

    reset
  end

  def reset(ratio=nil)
    @scale      = @frame.x / @image.width
    @max_width  = [@image.width, @frame.x].max
    @max_height = [@image.height, @frame.y].max
    @min_width  = @image.width / 2.5
    @min_height = @image.height / 2.5
    @ratio      = ratio || @frame.x / @frame.y

    @angle      = 0
    @rectangle  = [0,0, @image.width, @image.height]
  end

  def angle=(angle)
    @angle = angle
  end

  def rectangle=(rectangle)
    @rectangle = rectangle
  end

  def turn(angle)
    @angle + angle
  end

  def zoom(scale)
    new_width  = @rectangle[2] * scale
    new_height = @rectangle[3] * scale
    new_height = @rectangle[3] if new_width/new_height > @ratio && new_height < @rectangle[3]

    if scale > 1
      new_width  = @max_width  if new_width  > @max_width
      new_height = @max_height if new_height > @max_height
    else
      new_width  = @min_width  if new_width  < @min_width
      new_height = @min_height if new_height < @min_height
    end

    [
      @rectangle[0] - (new_width  - @rectangle[2]) / 2,
      @rectangle[1] - (new_height - @rectangle[3]) / 2,
      new_width, new_height
    ]
  end

  def move(offset)
    new_x = @rectangle[0] - offset.x
    new_y = @rectangle[1] + offset.y

    new_x = new_x < 0 ? 0 : new_x + @rectangle[2] > @max_width  ? @rectangle[0] : new_x
    new_y = new_y < 0 ? 0 : new_y + @rectangle[3] > @max_height ? @rectangle[1] : new_y

    [ new_x, new_y, @rectangle[2], @rectangle[3] ]
  end

end
