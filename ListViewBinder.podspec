#
# Be sure to run `pod lib lint ListViewBinder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ListViewBinder'
  s.version          = '1.0.0'
  s.summary          = '对rxDataSource的使用封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    对RxDataSource的使用封装
                       DESC

  s.homepage         = 'https://github.com/jacknathan'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jacknathan' => 'a63561158@163.com' }
  s.source           = { :git => 'https://github.com/jacknathan/ListViewBinder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ListViewBinder/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ListViewBinder' => ['ListViewBinder/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "RxDataSources", "~> 5.0"
  s.dependency "RxSwift", "~> 6.0"
  s.dependency "RxRelay", "~> 6.0"
  s.dependency "EmptyDataSet-Swift", "~> 5.0"
  s.dependency "Differentiator"
  
  s.swift_versions = ['4.0', '5.0']
end
