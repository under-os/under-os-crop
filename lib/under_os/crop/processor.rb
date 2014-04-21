class UnderOs::Crop::Processor

  def initialize
    @tilt_filter = CIFilter.filterWithName("CIStraightenFilter")
    @turn_filter = CIFilter.filterWithName("CIAffineTransform")
    @crop_filter = CIFilter.filterWithName("CICrop")
    @context     = begin
      gl_context = EAGLContext.alloc.initWithAPI(KEAGLRenderingAPIOpenGLES2)
      options    = {KCIContextWorkingColorSpace => nil}
      CIContext.contextWithEAGLContext(gl_context, options:options)
    end
  end

  def image=(image)
    resize(@original = image).tap do |ui_image|
      @resized_original = ui_image
    end
  end

  def reset
    @resized_original.tap do |ui_image|
      @working = CIImage.alloc.initWithImage(ui_image)
    end
  end

  def turn(angle)
    transform = NSValue.valueWithCGAffineTransform(CGAffineTransformMakeRotation(angle))
    @turn_filter.setValue(transform, forKey:"inputTransform")
    reset
    apply(@turn_filter).tap{ |image| @working = CIImage.alloc.initWithImage(image)  }
    apply(@tilt_filter)
  end

  def tilt(angle)
    @tilt_filter.setValue(angle, forKey:"inputAngle")
    apply @tilt_filter
  end

  def crop(x, y, width, height)
    rectangle = CIVector.vectorWithX(x, Y:y, Z:width, W:height)
    @crop_filter.setValue(rectangle, forKey:'inputRectangle')
    apply @crop_filter
  end

  def render(*crop_rect)
    @_working_image = @working

    @working = CIImage.alloc.initWithImage(@original)
    @working = CIImage.alloc.initWithImage(apply(@turn_filter))
    @working = CIImage.alloc.initWithImage(apply(@tilt_filter))

    crop(*crop_rect).tap{ |i| @working = @_working_image }
  end

protected

  def apply(filter)
    filter.setValue(@working, forKey: 'inputImage')

    image    = filter.outputImage
    cg_image = @context.createCGImage(image, fromRect:image.extent)
    image    = UIImage.imageWithCGImage(cg_image)

    CGImageRelease(cg_image)
    filter.setValue(nil, forKey: 'inputImage')

    image
  end

  def resize(image)
    max_width = UOS::Screen.size.x * 4 # double the retina for zoom
    ratio     = max_width / image.size.width
    new_size  = CGSizeMake(max_width, image.size.height * ratio)

    UIGraphicsBeginImageContext(new_size)
    image.drawInRect(CGRectMake(0,0,new_size.width,new_size.height))
    new_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    new_image
  end
end
