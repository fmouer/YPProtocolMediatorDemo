Pod::Spec.new do |s|
  s.name             = 'BuglyModule'
  s.version          = '1.0.0'
  s.license      = { :type => "Copyright", :text => "Copyright © 2016 fmouer All rights reserved." }
  s.summary  = 'ModuleProtocol for Trip'
  s.homepage = 'http://www.gnu.org/licenses/'
  s.description = 'BuglyModule'
  s.author           = { 'huangzhimou' => 'huangzm1@fmouercom' }
  s.source           = { :git => 'http://test/ModuleProtocol.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Classes/**/*'

  s.dependency 'ModuleProtocol/UserCenterProtocol'
  s.dependency 'YPProtocolMediator'

  #s.subspec 'BizService' do |sp|
  #  sp.source_files = 'BizService/Sources/**/*'
  #  sp.dependency 'TripExternalFramework'
  #end


end
