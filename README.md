# UnderOS Crop

This is a nice image crop plugin for the [under-os](http://under-os.com) project.

## Usage

Add it to your `Gemfile`

```ruby
gem `under-os`
gem `under-os-crop`
```

Then you can either use it as a `CROP` element in your HTML markup

```html
<page title="Image crop">
  <crop id="the-crop"></crop>
</page>
```

Or spawn it programmatically in your `UOS::Page` controller

```ruby
class CropPage < UOS::Page
  def initialize
    @crop = UOS::Crop.new
  end
end
```

Either way the `UOS::Crop` class is a subclass of the `UOS::UI::View` so
all the normal under-os rules apply.

## Cropping images

Once you've got an instance of the `UOS::Crop` class, you can give it an
instance of a `UIImage` class as the image that needs to be cropped and
then read it the same way from the same `#src` property

```ruby
# set a new image to crop
@crop.src = UIImage.alloc.initWithImage("test.png")

# whenever the user is done, you can read it back
@crop.src # -> the cropped image
```

## Setting Aspect Ratio

You can set an aspect ratio for the crop widget as well through the `#ratio` property

```ruby
@crop.ratio = "3:4"
@crop.ratio = "1:1"
@crop.ratio = nil # no ratio
```

## Tilting & Turning

You also can set the image tilt programmatically (say from a slider in UI) or turn
the image 90 degrees with the `#turn` and `#tilt` methods

```ruby
@crop.turn Math::PI / 4  # turn 90 degrees
@crop.tilt Math::PI / 12 # tilt image by 30 degrees
```

## Copyright & License

All the code in this repository is released under the terms of the MIT license

Copyright (C) 2014 Nikolay Nemshilov


