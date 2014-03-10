class UnderOs::Crop::Window < UnderOs::UI::View
  MIN_SIZE = 50

  attr_accessor :ratio

  def initialize(options={})
    super class: 'window'

    append @point_nw = Point.new('nw')
    append @point_nc = Point.new('nc')
    append @point_ne = Point.new('ne')
    append @point_cw = Point.new('cw')
    append @point_ce = Point.new('ce')
    append @point_sw = Point.new('sw')
    append @point_sc = Point.new('sc')
    append @point_se = Point.new('se')

    append @bar_h1   = Bar.new('horizontal')
    append @bar_h2   = Bar.new('horizontal')

    append @bar_v1   = Bar.new('vertical')
    append @bar_v2   = Bar.new('vertical')
  end

  def reposition(width, height, x, y)
    @_.frame = [[x, y], [width, height]]

    @point_nw.position y: 0, x: 0
    @point_nc.position y: 0, x: (width - @point_nc.size.x)/2
    @point_ne.position y: 0, x: width - @point_ne.size.x

    @point_ce.position x: 0, y: (height - @point_ce.size.y)/2
    @point_cw.position x: width - @point_cw.size.x, y: (height - @point_cw.size.y) / 2

    @point_sw.position y: height - @point_sw.size.y, x: 0
    @point_sc.position y: height - @point_sc.size.y, x: (width - @point_sc.size.x)/2
    @point_se.position y: height - @point_se.size.y, x: width - @point_se.size.x

    @bar_h1._.frame = [[0, height/3], [width, @bar_h1.size.y]]
    @bar_h2._.frame = [[0, height/3 * 2], [width, @bar_h2.size.y]]

    @bar_v1._.frame = [[width/3, 0], [@bar_v1.size.x, height]]
    @bar_v2._.frame = [[width/3 * 2, 0], [@bar_v2.size.x, height]]
  end

  def touch_direction(position)
    window_pos = @_.convertPoint(@_.bounds.origin, toView: nil)

    x = position.x - window_pos.x
    y = position.y - window_pos.y

    w_6 = size.x / 6
    h_6 = size.y / 6

    h_l = x < w_6 ? 'w' : x > w_6 * 5 ? 'e' : 'c'
    v_l = y < h_6 ? 'n' : y > h_6 * 5 ? 's' : 'c'

    v_l + h_l
  end

  class Point < UnderOs::UI::View
    def initialize(position)
      super class: "point #{position}"
    end
  end

  class Bar < UnderOs::UI::View
    def initialize(orientation)
      super class: "bar #{orientation}"
    end
  end
end
