
    Pod::Spec.new do |s|  
      
      s.name         = "WHTimePicker"  
      s.version      = "1.0.5"  
      s.summary      = "好用的时间选择器."  
      s.homepage     = "https://github.com/remember17/WHTimePicker"  
      s.license      = "MIT"  
      s.author       = { "wuhao" => "503007958@qq.com" }  
      s.platform     = :ios, "7.0"  
      s.source       = { :git => "https://github.com/remember17/WHTimePicker.git", :tag => s.version }  
      s.source_files  = "WHTimePicker", "WHTimePicker/*.{h,m}"  
      s.framework  = "UIKit"  
      s.requires_arc = true   
      s.dependency 'Masonry'

    end  