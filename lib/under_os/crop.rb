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
      append @window   = Window.new

      @processor = Processor.new(@window)
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
      super(*args).tap{  @window.expand @ratio if @window }
    end

    def src
      @processor.render
    end

    def src=(image)
      @processor.image = image
      reset
    end

    def reset
      @scroll.image = @processor.reset
    end

    def turn(angle)
      @scroll.image = @processor.turn(angle)
    end

    def tilt(angle)
      return if @_working; @_working = true
      @scroll.image = @processor.tilt(angle)
      @_working = false
    end
  end
end
