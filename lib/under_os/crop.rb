#
# An image crop UI
#
module UnderOs
  class Crop < UnderOs::UI::View
    tag :crop

    attr_reader :ratio, :image

    def initialize(options={})
      super options.merge(class: 'crop')

      append @scroll   = Scroll.new
      # append @window   = Window.new
      # append @overlay1 = Overlay.new
      # append @overlay2 = Overlay.new
    end

    def ratio=(ratio)
      ratio = ratio.to_s
      ratio = "#{@original.size.width}:#{@original.size.height}" if ratio == 'true'

      if m = ratio.match(/^([\d\.+]+):([\d\.]+)$/)
        @ratio = m[1].to_f / m[2].to_f
      else
        @ratio = nil
      end

      reset
    end

    def src
      #puts @scroll.image_rect
      # render and return
      @original
    end

    def src=(image)
      @original = image
      reset
    end

    def reset
      @scroll.image = @original
      @processor = Processor.new(@original)
    end

    def turn(angle)
      @scroll.image = @processor.turn(angle)
    end

    def tilt(angle)
      @scroll.image = @processor.tilt(angle)
    end
  end
end
