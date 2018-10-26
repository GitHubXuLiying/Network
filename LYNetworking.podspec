Pod::Spec.new do |s|
  s.name         = "LYNetworking" 
  s.version      = "1.0.0"        
  s.license      = "MIT"          
  s.summary      = "AFNetworking封装" # 

  s.homepage     = "https://github.com/GitHubXuLiying/Network" # 你的主页
  s.source       = { :git => "https://github.com/GitHubXuLiying/Network.git", :tag => "#{s.version}" }
  s.source_files = "LYNetworking/*.{h,m}" 


  s.subspec "Category" do |ss|
    ss.source_files = "LYNetworking/Category/*.{h,m}" 
  end

  s.subspec "Networking" do |ss|
    ss.source_files = "LYNetworking/Networking/*.{h,m}" 
    ss.dependency "LYNetworking/Category"
    ss.dependency "AFNetworking" 
  end

  s.requires_arc = true 
  s.platform     = :ios, "7.0" 
  s.frameworks   = "UIKit", "Foundation" 
  s.dependency  "AFNetworking" 
  s.dependency  "PINCache" 
  
  # User
  s.author             = { "LY" => "850401552@qq.com" } 
  s.social_media_url   = "https://github.com/GitHubXuLiying" 

end