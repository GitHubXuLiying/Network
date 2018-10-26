Pod::Spec.new do |s|
  s.name         = "LYNetworkingKit" 
  s.version      = "1.0.4"        
  s.license      = "MIT"          
  s.summary      = "AFNetworking封装.增加取消指定的请求,避免重复请求，同时发起多个请求，缓存等功能" # 

  s.homepage     = "https://github.com/GitHubXuLiying/Network" # 你的主页
  s.source       = { :git => "https://github.com/GitHubXuLiying/Network.git", :tag => "#{s.version}" }
  s.source_files = "LYNetworkingKit/*.{h,m}" 


  s.subspec "Category" do |ss|
    ss.source_files = "LYNetworkingKit/Category/*.{h,m}" 
  end

  s.subspec "Networking" do |ss|
    ss.source_files = "LYNetworkingKit/Networking/*.{h,m}" 
    ss.dependency "LYNetworkingKit/Category"
   # ss.dependency "AFNetworking" 
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