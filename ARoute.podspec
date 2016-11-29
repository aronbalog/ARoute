Pod::Spec.new do |s|

  s.name         = "ARoute"
  s.version      = "0.0.14"
  s.summary      = "ARoute"

  s.description  = <<-DESC
	ARoute for every dev!
                   DESC

  s.homepage     = "https://github.com/aronbalog"
  s.license      = "MIT"
  s.author       = { "Aron Balog" => "aronbalog@gmail.com" }
  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/aronbalog/ARoute.git", :tag => "0.0.14" }
  s.source_files  = "ARoute", "ARoute/**/*.{h,m}"
  s.public_header_files = "ARoute/Classes/Public/**/*.h"
  s.requires_arc = true
  s.prefix_header_file = 'ARoute/Support/ARoutePrefixHeader.pch'
end