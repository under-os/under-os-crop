class UnderOs::Crop::Processor

  def initialize
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
    @original = CIImage.alloc.initWithImage(image)
  end

  def turn(angle)
    transform = NSValue.valueWithCGAffineTransform(CGAffineTransformMakeRotation(angle))
    @turn_filter.setValue(transform, forKey:"inputTransform")
    render(@turn_filter).tap{ |image| self.image = image  }
  end

  def tilt(angle)
    @tilt_filter.setValue(angle, forKey:"inputAngle")
    render @tilt_filter
  end

  def crop(rect)
    rectangle = CIVector.vectorWithX(rect[0], Y:rect[1], Z:rect[2], W:rect[3])
    @crop_filter.setValue(rectangle, forKey:'inputRectangle')
    render @crop_filter
  end

protected

  def render(filter)
    filter.setValue(@original, forKey: 'inputImage')

    image    = filter.outputImage
    cg_image = @context.createCGImage(image, fromRect:image.extent)
    image    = UIImage.imageWithCGImage(cg_image)

    CGImageRelease(cg_image)

    image
  end
end
