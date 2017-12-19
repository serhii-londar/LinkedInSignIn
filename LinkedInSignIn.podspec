#
# Be sure to run `pod lib lint LinkedInSignIn.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LinkedInSignIn'
  s.version          = '0.0.11'
  s.summary          = '  Small swift library which help easy get access token from linkedin.com.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Simple view controller writed on pure Swift to login and retrieve access token from linkedin.com
                       DESC

  s.pod_target_xcconfig = { "SWIFT_VERSION" => "4.0" }
  s.homepage         = 'https://github.com/serhii-londar/LinkedInSignIn'
  s.screenshots     = 'https://i.imgur.com/R8haoKu.png', 'https://i.imgur.com/QzjcjDR.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Serhii Londar' => 'serhii.londar@gmail.com' }
  s.source           = { :git => 'https://github.com/serhii-londar/LinkedInSignIn.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/serhii_londar'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LinkedInSignIn/Classes/**/*'

  s.resource = 'LinkedInSignIn/**/*.storyboard'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MBProgressHUD', '~> 0.9'
end
