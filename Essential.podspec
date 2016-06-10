Pod::Spec.new do |s|

  s.name         = "Essential"
  s.version      = "1.0"
  s.summary      = "Essential code for swift project"
  s.description  = "Essential code for swift project"
  s.homepage     = "https://github.com/ntaku/ASSwiftEssential"

  s.author       = { "Takuto Nishioka" => "ntakuto@gmail.com" }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/ntaku/ASSwiftEssential.git", :tag => "#{s.version}" }
  s.source_files = "Essential/*.{swift}"

end
