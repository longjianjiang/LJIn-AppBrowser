Pod::Spec.new do |s|
  s.name             = 'LJIn-AppBrowser'
  s.version          = '0.0.1'
  s.summary          = 'one In-App browser'
  s.description      = <<-DESC
                       An easy tool to use as In-App Browser.
                         DESC
  s.homepage         = 'https://github.com/longjianjiang/LJIn-AppBrowser'
  s.license          = 'MIT'
  s.author           = { 'longjianjiang' => "616393956@qq.com" } 
  s.source           = { :git => 'https://github.com/longjianjiang/LJIn-AppBrowser.git', :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
	
  s.source_files     = 'LJInAppBrowser/Category/*.{h,m}', 'LJInAppBrowser/NJKWebViewProgress/*.{h,m}', 'LJInAppBrowser/**/*.{h,m}' 
  s.resource     = 'LJInAppBrowser/LJInAppBrowser.bundle'
  s.dependency 'UMengSocial'
  s.frameworks        = 'UIKit'
end
