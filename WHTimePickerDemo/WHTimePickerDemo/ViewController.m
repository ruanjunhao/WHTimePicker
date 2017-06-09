//
//  ViewController.m
//  WHTimePickerDemo
//
//  Created by 吴浩 on 2017/6/9.
//  Copyright © 2017年 remember17. All rights reserved.
//

#import "ViewController.h"
#import "WHTimePicker.h"

@interface ViewController () <WHPickerDelegate>

@end

@implementation ViewController {
    UIButton *button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    button = [UIButton wh_buttonWithTitle:@"选择时间" backColor:[UIColor blackColor] backImageName:nil titleColor:[UIColor whiteColor] fontSize:14 frame:CGRectMake(0, 0, 200, 40) cornerRadius:7];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(setupTimePicker) forControlEvents:UIControlEventTouchUpInside];
}


/** 创建时间选择器 */
-(void)setupTimePicker{
    
    WHTimePicker *picker = [WHTimePicker timePickerWithType:allDateArray Frame:self.view.bounds];
    picker.delegate = self;
    
    //一般添加到keywindow, 覆盖导航栏
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:picker];
    

    // 顶部确定栏背景颜色,默认天蓝色
//    picker.topTitleColor = [UIColor lightGrayColor];
    // 顶部"确定","类型","取消"按钮的文字颜色,默认白色
//    picker.topBackColor = [UIColor blackColor];
}

/** 代理方法 */
-(void)PickerSelectorIndixString:(NSString *)str {
    [button setTitle:str forState:UIControlStateNormal];
}

/** 代理方法 */
- (void)PickerSelectorCancel {
    NSLog(@"时间选择器消失了~");
}
@end
