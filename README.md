# WHTimePicker
好用的时间选择器

### ！注意：需要用到 Masonry 框架，请提前准备好‘Masonry’
```objc
在WHTimePicker.h文件中导入了#import "Masonry.h"
如果编译报错，可能是项目中没有Masonry
```

## 使用方法 

1. 导入头文件 
```objc
 #import "WHTimePicker.h"
```

2. 添加代理
```objc
@interface ViewController () <WHPickerDelegate>
```

3. 初始化创建WHTimePicker
```objc
/** 创建时间选择器 */
-(void)setupTimePicker{
    
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
}
```

4. 实现代理方法一
```objc
/** 代理方法，拿到选择的时间 */
-(void)PickerSelectorIndixString:(NSString *)str {
    [button setTitle:str forState:UIControlStateNormal];
}
```

5. 实现代理方法二
```objc
/** 代理方法，时间选择器消失的时候自动调用*/
- (void)PickerSelectorCancel {
    NSLog(@"时间选择器消失了~");
}
```
### 如果觉得好用就给个Star吧😁

## MIT LICENSE
