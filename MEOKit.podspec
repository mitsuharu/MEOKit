Pod::Spec.new do |s|

  s.name         = "MEOKit"
  s.version      = "0.3.3"
  s.summary      = "my libraries"

  s.description  = <<-DESC
		   - Swift5
                   DESC

  s.homepage     = "https://github.com/mitsuharu/MEOKit"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Mitsuharu Emoto" => "mthr1982@gmail.com" }
  # s.social_media_url = "https://twitter.com/mitsuharu_e"

  s.platform = :ios, "10.0"

  s.source       = { :git => "https://github.com/mitsuharu/MEOKit.git", :tag => "#{s.version}" }
  s.source_files  = "MEOKit/**/*.swift"
  s.exclude_files = ""

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # s.swift_version = '>= 3.2'

end
