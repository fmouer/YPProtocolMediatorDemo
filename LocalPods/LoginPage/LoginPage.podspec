Pod::Spec.new do |s|
  s.name             = 'LoginPage'
  s.version          = '1.0.0'
  s.license      = { :type => "Copyright", :text => "Copyright © 2016 fmouer All rights reserved." }
  s.summary  = 'LoginPage for Trip'
  s.homepage = 'http://www.gnu.org/licenses/'
  s.description = 'LoginPage'
  s.author           = { 'huangzhimou' => 'huangzm1@fmouercom' }
  s.source           = { :git => 'http://test/ModuleProtocol.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Classes/**/*'

 
  #s.subspec 'BizService' do |sp|
  #  sp.source_files = 'BizService/Sources/**/*'
  #  sp.dependency 'Guardian'
  #  sp.dependency 'TripExternalFramework'
  #end


end
