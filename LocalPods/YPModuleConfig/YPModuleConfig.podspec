Pod::Spec.new do |s|
  s.name             = 'YPModuleConfig'
  s.version          = '1.0.0'
  s.license      = { :type => "Copyright", :text => "Copyright © 2016 fmouer All rights reserved." }
  s.summary  = 'YPModuleConfig for Trip'
  s.homepage = 'http://www.gnu.org/licenses/'
  s.description = 'YPModuleConfig'
  s.author           = { 'huangzhimou' => 'huangzm1@fmouercom' }
  s.source           = { :git => 'http://test/YPModuleConfig.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files        = ['Classes/**/**/*', 'Classes/**/*','Classes/*']


end
