Pod::Spec.new do |s|

  s.name         = "ASSwiftEssential"
  s.version      = "0.0.1"
  s.summary      = "ASSwiftEssential"
  s.description  = "The collection of swift essential code."
  s.homepage     = "https://github.com/ntaku/ASSwiftEssential"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
 
  s.author       = { "Takuto Nishioka" => "ntakuto@gmail.com" }

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/ntaku/ASSwiftEssential.git", :tag => "#{s.version}" }

  s.source_files  = "ASSwiftEssential/*.{swift}"

end
