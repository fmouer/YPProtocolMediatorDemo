Pod::Spec.new do |s|
  s.name             = 'ModuleProtocol'
  s.version          = '1.0.0'
  s.license      = { :type => "Copyright", :text => "Copyright © 2016 fmouer All rights reserved." }
  s.summary  = 'ModuleProtocol for Trip'
  s.homepage = 'http://www.gnu.org/licenses/'
  s.description = 'ModuleProtocol'
  s.author           = { 'huangzhimou' => 'huangzm1@fmouercom' }
  s.source           = { :git => 'http://test/ModuleProtocol.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  #s.subspec 'CommonProtocol' do |sp|
  #    sp.source_files = 'Classes/Common/**/*'
  #end

  s.subspec 'UserCenterProtocol' do |sp|
      sp.source_files = 'Classes/UserCenter/**/*'
  end

  #s.subspec 'MQTTProtocol' do |sp|
  #    sp.source_files = 'Classes/MQTT/**/*'
  #end

	s.subspec 'LoginProtocol' do |sp|
      sp.source_files = 'Classes/Login/**/*'
  end

s.subspec 'HomePageProtocol' do |sp|
      sp.source_files = 'Classes/HomePage/**/*'
  end
  #s.subspec 'BizService' do |sp|
  #  sp.source_files = 'BizService/Sources/**/*'
  #  sp.dependency 'Guardian'
  #  sp.dependency 'TripExternalFramework'
  #end


end
