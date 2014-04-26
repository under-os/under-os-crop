#
# An image crop UI
#
module UnderOs
  class Crop < UnderOs::UI::View
    tag :crop

    attr_reader :ratio, :image

    def initialize(options={})
      super options.merge(class: 'crop')

      append @scroll = Scroll.new
      append @window = Window.new

      @processor = Processor.new
      self.ratio = nil
    end

    def ratio=(ratio)
      ratio = ratio.to_s
      ratio = "#{@original.size.width}:#{@original.size.height}" if ratio == 'true'

      if m = ratio.match(/^([\d\.+]+):([\d\.]+)$/)
        @ratio = m[1].to_f / m[2].to_f
      else
        @ratio = nil
      end

      @window.expand @ratio if self.size.x > 0
    end

    def repaint(*args)
      super(*args).tap{ @window.expand @ratio if @window }
    end

    def src
      @processor.render *original_crop_rectangle
    end

    def src=(image)
      @processor.image = image
      @original = @processor.image # fixed original
      reset
    end

    def reset
      @scroll.resetting!
      render { @processor.reset }
    end

    def turn(angle)
      render { @processor.turn(angle) }
    end

    def tilt(angle)
      render { @processor.tilt(angle) }
    end

  protected

    def render(&block)
      return if @_working; @_working = true

      Dispatch::Queue.new("uos.gems.crop.tilt").async do
        new_image = block.call

        Dispatch::Queue.main.async do
          @scroll.image = new_image
          @_working = false
        end
      end
    end

    def original_crop_rectangle
      content_size    = @scroll.contentSize / @scroll.scale
      crop_offset     = @scroll.contentOffset / @scroll.scale + @window.position / 2 + 1
      crop_frame      = @window.size / @scroll.scale

      crop_offset.x   = 0 if crop_offset.x < 0 # tall image
      crop_offset.y   = 0 if crop_offset.y < 0 # wide image

      crop_frame.x    = content_size.x if crop_frame.x > content_size.x
      crop_frame.y    = content_size.y if crop_frame.y > content_size.y

      original_is_h   = @original.size.width / @original.size.height > 1
      content_is_h    = content_size.x / content_size.y > 1
      original_scale  = @original.size.width / content_size.__send__(original_is_h == content_is_h ? :x : :y)

      original_offset = crop_offset * original_scale
      original_frame  = crop_frame * original_scale

      [original_offset.x, original_offset.y, original_frame.x, original_frame.y]
    end
  end
end
