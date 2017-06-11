//
//  WHTimePicker.h
//  WHTimePicker
//  https://github.com/remember17/WHTimePicker
//  Created by 吴浩 on 2017/6/9.
//  Copyright © 2017年 remember17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WHButton.h"
#import "UIColor+WHColor.h"
#import "NSString+WHString.h"
#import "Masonry.h"

@protocol WHPickerDelegate <NSObject>

@optional

/**
 点击确定的时候自动调用此方法
 @param string 返回的string
 */
- (void)getSelectedString:(NSString *)string;

/** 选择器消失的时候调用此方法 */
- (void)timePickerDisappare;

@end

/** 选择器类型 */
typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    GenderArray,     //性别
    allDateArray,    //年月日时分
    DateArray,       //年月日
};

@interface WHTimePicker : UIView

/**
 初始化时间选择器

 @param type 选择器类型
 @param frame 选择器frame,直接填写self.view.bounds
 */
+ (WHTimePicker *)timePickerWithType:(ARRAYTYPE)type Frame:(CGRect)frame;


/** 选择器类型 */
@property (nonatomic, assign) ARRAYTYPE arrayType;

/** 顶部确定栏背景颜色,默认天蓝色 */
@property (nonatomic, strong) UIColor *topBackColor;

/** 顶部"确定","类型","取消"按钮的文字颜色,默认白色 */
@property (nonatomic, strong) UIColor *topTitleColor;

/** 代理 */
@property (nonatomic,assign)id<WHPickerDelegate>delegate;

@end
