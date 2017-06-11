# WHTimePicker
好用的时间选择器, 支持cocoapods， 可以直接在项目中 pod ‘WHTimePicker’
如果没找到, 请先pod setup, 然后再pod ‘WHTimePicker’

### ！注意：需要用到 Masonry 框架
```objc
在WHTimePicker.h文件中导入了#import "Masonry.h"
如果你的项目中没有Masonry,会自动帮你导入Masonry
```

 ![img](https://github.com/remember17/WHTimePicker/blob/master/img-folder/example1.gif)

## 使用方法 

1. 导入头文件 
```objc
 a>> 直接在本网页下载使用：#import "WHTimePicker.h"
 b>> 或者利用CocoaPods安装到项目中：#import <WHTimePicker.h>
```

2. 添加代理
```objc
@interface ViewController () <WHPickerDelegate>
```

3. 初始化创建WHTimePicker
```objc
    //类方法创建
    WHTimePicker *picker = [WHTimePicker timePickerWithType:allDateArray Frame:self.view.bounds];
    picker.delegate = self;
    
    //一般添加到keywindow, 覆盖导航栏
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:picker];
    
    // 顶部确定栏背景颜色,如果不设置，默认为天蓝色
//    picker.topTitleColor = [UIColor lightGrayColor];
    // 顶部"确定","类型","取消"按钮的文字颜色,如果不设置，默认为白色
//    picker.topBackColor = [UIColor blackColor];
```

4. 实现代理方法一
```objc
/** 代理方法一 返回选择的字符串*/
- (void)getSelectedString:(NSString *)string {
    NSLog(@"你选择了%@",string);
   [button setTitle:string forState:UIControlStateNormal];
}
```

5. 实现代理方法二
```objc
/** 代理方法二 时间选择器消失的时候回调*/
- (void)timePickerDisappare {
    NSLog(@"时间选择器消失了~");
}
```
### 如果觉得好用就给个Star吧,谢谢😁

## MIT LICENSE
