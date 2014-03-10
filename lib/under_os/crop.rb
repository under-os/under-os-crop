#
# An image crop UI
#
class UnderOs
  class Crop < UnderOs::UI::View

    attr_reader :ratio

    def initialize(options={})
      super class: 'cropper'

      UnderOs::App.history.current_page.stylesheet.load "cropper.css"

      append @window         = Window.new
      append @overlay_top    = Overlay.new
      append @overlay_left   = Overlay.new
      append @overlay_right  = Overlay.new
      append @overlay_bottom = Overlay.new

      self.ratio = nil # free-form

      on :touchstart, :save_position
      on :touchmove,  :move_window

      UnderOs::App.history.current_page.view.on(:touchend) { stop_resize }
    end

    def original_image
      parent._.image if parent.is_a?(UOS::UI::Image)
    end

    def ratio=(ratio)
      ratio = ratio.to_s
      ratio = "#{original_image.size.width}:#{original_image.size.height}" if ratio == 'true'

      if m = ratio.match(/^([\d\.+]+):([\d\.]+)$/)
        @ratio = m[1].to_f / m[2].to_f
      else
        @ratio = nil
      end

      expand
    end

    def repaint(*args)
      super *args
      expand
      self
    end

    def expand
      return if size.x == 0 || ! @window # not initialized yet

      @calculator = Calculator.new(self)

      reposition *@calculator.max_window_frame
    end

    def reposition(width, height, x, y)
      @window.reposition(width, height, x, y)
      resize_overlays(width, height, x, y)
    end

    def resize_overlays(width, height, x, y)
      @overlay_top._.frame    = [[0,0], [size.x, y]]
      @overlay_left._.frame   = [[0,y], [x, height]]
      @overlay_right._.frame  = [[x+width, y], [size.x-x-width, height]]
      @overlay_bottom._.frame = [[0, y+height], [size.x, size.y-y-height]]
    end

    def save_position(event)
      @directions = event.touches.map do |touch|
        @window.touch_direction(touch.position)
      end

      @prev_position = event.touches.map(&:position)
    end

    def move_window(event)
      return if ! @prev_position

      reposition *@calculator.new_window_frame(@prev_position, event.touches.map(&:position), @directions)

      @prev_position = event.touches.map(&:position)
    end

    def stop_resize
      @prev_position = nil
    end

  end
end
