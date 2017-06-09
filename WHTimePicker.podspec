Pod::Spec.newdo|s|

s.name ='WHTimePicker'

s.version ='1.0.0'

s.license ='MIT'

s.summary ='好用的时间选择器.'

s.homepage ='https://github.com/remember17/WHTimePicker'

s.authors = {'wuhao'=>'503007958@qq.com'}

s.source = {:git=>'https://github.com/remember17/WHTimePicker.git',:tag=> s.version.to_s }

s.requires_arc =true

s.ios.deployment_target ='8.0'

s.source_files ='WHTimePicker/*.{h,m}'

s.resources ='WHTimePicker/images/*.{png,xib}'

s.dependency 'Masonry'

end