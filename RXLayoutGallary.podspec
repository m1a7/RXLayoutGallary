#
# Be sure to run `pod lib lint RXLayoutGallary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RXLayoutGallary'
  s.version          = '1.1.2'
  s.summary          = 'With help RXLayoutGallary add photos to grid.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = 'Using the library you can add from one up to five photos. These photos will be posted of the beautiful grid.'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/m1a7/RXLayoutGallary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'm1a7' => 'thisismymail03@gmail.com' }
  s.source           = { :git => 'https://github.com/m1a7/RXLayoutGallary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RXLayoutGallary/Classes/**/*.{h,m}'

s.resource_bundles = {
    'RXLayoutGallary' => ['RXLayoutGallary/Assets/*.png']
}

    s.public_header_files =  'RXLayoutGallary/Classes/*.h'

    #s.public_header_files   = 'Pod/Development Pods/RXLayoutGallary/*.h'
    #s.public_header_files   = 'Pod/Classes/**/*.h'
    #s.public_header_files =  'RXLayoutGallary/Classes/PublicHeaders/*.h'
    #s.vendored_frameworks   = 'Framework/RXLayoutGallary.framework'
    #s.vendored_frameworks = "RXLayoutGallary-0.1.0/RXLayoutGallary.framework"


   s.frameworks = 'UIKit'
   s.dependency 'SDWebImage',      '~> 4.0'
   s.dependency 'SDWebImage/GIF'
   s.dependency 'FLAnimatedImage', '~> 1.0'

end
