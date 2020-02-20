
Pod::Spec.new do |spec|
  spec.name         = "DBNetworkKit"
  spec.version      = "0.0.18"
  spec.summary      = "A small framework to manage the Network requests."
  spec.description  = "A small framework to manage the Network requests in the apps."
  spec.homepage     = "https://github.com/db-digital/DBNetworkKit"
  spec.license      = "MIT"
  spec.author       = { "Nitin" => "nitin.kumar@dbdigital.in" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "git@github.com:db-digital/DBNetworkKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "DBNetworkKit", "DBNetworkKit/**/*.{h,m,swift}"
  spec.exclude_files = "DBNetworkKit/Exclude"
  spec.dependency 'DBLoggingKit'
end
