class UnderOs::Crop::Processor

  def initialize(window)
    @crop_window = window
    @tilt_filter = CIFilter.filterWithName("CIStraightenFilter")
    @turn_filter = CIFilter.filterWithName("CIAffineTransform")
    @crop_filter = CIFilter.filterWithName("CICrop")
    @context   ||= begin
      gl_context = EAGLContext.alloc.initWithAPI(KEAGLRenderingAPIOpenGLES2)
      options    = {KCIContextWorkingColorSpace => nil}
      CIContext.contextWithEAGLContext(gl_context, options:options)
    end
  end

  def image=(image)
    @original = image
  end

  def reset
    resize(@original).tap do |ui_image|
      @working = CIImage.alloc.initWithImage(ui_image)
    end
  end

  def turn(angle)
    transform = NSValue.valueWithCGAffineTransform(CGAffineTransformMakeRotation(angle))
    @turn_filter.setValue(transform, forKey:"inputTransform")
    apply(@turn_filter).tap{ |image| @working = CIImage.alloc.initWithImage(image)  }
    apply(@tilt_filter)
  end

  def tilt(angle)
    @tilt_filter.setValue(angle, forKey:"inputAngle")
    apply @tilt_filter
  end

  def crop(rect)
    rectangle = CIVector.vectorWithX(rect[0], Y:rect[1], Z:rect[2], W:rect[3])
    @crop_filter.setValue(rectangle, forKey:'inputRectangle')
    apply @crop_filter
  end

  def render
    @original
  end

protected

  def apply(filter)
    filter.setValue(@working, forKey: 'inputImage')

    image    = filter.outputImage
    cg_image = @context.createCGImage(image, fromRect:image.extent)
    image    = UIImage.imageWithCGImage(cg_image)

    CGImageRelease(cg_image)

    image
  end

  def resize(image)
    size      = UOS::Point.new(UOS::Screen.size * 2)
    ratio     = size.x * 2 / image.size.width
    new_size  = CGSizeMake(size.x * 2, image.size.height * ratio)

    UIGraphicsBeginImageContext(new_size)
    image.drawInRect(CGRectMake(0,0,new_size.width,new_size.height))
    new_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    new_image
  end
end
