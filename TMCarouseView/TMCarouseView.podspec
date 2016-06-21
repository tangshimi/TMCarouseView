Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TMCarouseView"
  s.version      = "1.1"
  s.summary      = "carouse"

  s.description  = <<-DESC
                  carouseView
                   DESC

  s.homepage     = "https://cocoapods.org"

  s.license      = { :type => 'Copyright',
      :text => <<-LICENSE
      Copyright 2015 tangshimi. All rights reserved.
      LICENSE
 }
  s.author    = "tangshimi"
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/tangshimi/TMCarouseView.git",:tag => "1.1" }

  s.source_files  = "TMCarouseView/TMCarouseView/TMCarouseView/*.{h,m}"
  s.requires_arc = true
  s.dependency "SDWebImage", "~> 3.7.3"

end
