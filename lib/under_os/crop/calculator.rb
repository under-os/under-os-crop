class UnderOs::Crop::Calculator
  MIN_SIZE = 100

  def initialize(cropper)
    @ratio    = cropper.ratio
    @size_x   = cropper.size.x
    @size_y   = cropper.size.y
    @offset_x = 0
    @offset_y = 0

    if cropper.original_image
      calculate_image_offset(cropper.original_image.size)
    end
  end

  def max_window_frame
    @max_width, @max_height = max_width_height_for(@ratio)
    @min_left = (@size_x - @max_width) / 2 + @offset_x
    @min_top  = (@size_y - @max_height) / 2 + @offset_y

    save_prev @max_width, @max_height, @min_left, @min_top
  end

  def new_window_frame(prev_pos, new_pos, directions)
    top    = @prev_top
    left   = @prev_left
    width  = @prev_widht
    height = @prev_height

    if prev_pos.size == 1
      diff_x = new_pos[0].x - prev_pos[0].x
      diff_y = new_pos[0].y - prev_pos[0].y

      case directions[0][0]
      when 's'
        height += diff_y
      when 'n'
        top    += diff_y
        height -= diff_y
      end

      case directions[0][1]
      when 'e'
        width  += diff_x
      when 'w'
        left   += diff_x
        width  -= diff_x
      end

      if directions[0] == 'cc'
        top  += diff_y
        left += diff_x
      end
    else # pan

    end

    height = minmax(height, MIN_SIZE, @max_height)
    width  = minmax(width,  MIN_SIZE, @max_width)
    left   = minmax(left,  @min_left, @min_left + @max_width - width)
    top    = minmax(top,    @min_top, @min_top + @max_height - height)

    save_prev width, height, left, top
  end

private

  def save_prev(width, height, left, top)
    @prev_top    = top
    @prev_left   = left
    @prev_widht  = width
    @prev_height = height

    [width, height, left, top]
  end

  def minmax(val, min, max)
    if val < min
      min
    elsif val > max
      max
    else
      val
    end
  end

  def calculate_image_offset(image)
    width  = image.width
    height = image.height

    if width > @size_x || height > @size_y
      ratio  = image.width / image.height
      width, height = max_width_height_for(ratio)
    end

    @offset_x = (@size_x - width) / 2
    @offset_y = (@size_y - height) / 2

    @size_x   = width
    @size_y   = height
  end

  def max_width_height_for(ratio)
    width  = @size_x
    height = ratio ? width / ratio : @size_y

    if height > @size_y
      height = @size_y
      width  = ratio ? height * ratio : @size_x
    end

    [width, height]
  end

end
