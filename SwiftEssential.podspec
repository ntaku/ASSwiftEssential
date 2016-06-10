Pod::Spec.new do |s|

  s.name         = "SwiftEssential"
  s.version      = "1.0.0"
  s.summary      = "Essential code for swift project"
  s.description  = "Essential code for swift project"
  s.homepage     = "https://github.com/ntaku/SwiftEssential"

  s.author       = { "Takuto Nishioka" => "ntakuto@gmail.com" }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/ntaku/SwiftEssential.git", :tag => "#{s.version}" }
  s.source_files = "SwiftEssential/*.{swift}"

end
