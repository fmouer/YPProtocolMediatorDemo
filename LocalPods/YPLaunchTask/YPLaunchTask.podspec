Pod::Spec.new do |s|
  s.name             = 'YPLaunchTask'
  s.version          = '1.0.0'
  s.license      = { :type => "Copyright", :text => "Copyright © 2016 fmouer All rights reserved." }
  s.summary  = 'YPLaunchTask for Trip'
  s.homepage = 'http://www.gnu.org/licenses/'
  s.description = 'YPLaunchTask'
  s.author           = { 'huangzhimou' => 'huangzm1@fmouercom' }
  s.source           = { :git => 'http://test/YPLaunchTask.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files        = ['Classes/**/**/*', 'Classes/**/*','Classes/*']


end
