Pod::Spec.new do |s|
  s.name = 'CPCardViewController'
  s.version = '0.0.1'
  s.ios.deployment_target = '7.0'
  s.license = 'MIT'
  s.summary = ''
  s.author = { 'cuppi' => 'cuppi413@yahoo.com' }
  s.description = ''
  s.source_files = 'CPCardViewController/*'
  s.requires_arc = true
  s.framework = 'UIKit'
  s.dependency 'SDWebImage'
end
