Pod::Spec.new do |s|
  s.name            = 'Cheapshot-PickerView'
  s.version         = '0.0.1'
  s.summary         = 'Light Picker View from Cheapshot project.'
  s.homepage        = 'https://github.com/buh/Cheapshot-PickerView'
  s.license         = 'MIT'
  s.author          = { 'Alexey Bukhtin' => 'bukhtin@gmail.com' }
  s.source          = { :git => 'https://github.com/buh/Cheapshot-PickerView.git', :tag => '0.0.1' }
  s.platform        = :ios, '5.0'
  s.requires_arc    = true
  s.source_files    = 'PickerView/CSPickerView.{h,m}'
end
