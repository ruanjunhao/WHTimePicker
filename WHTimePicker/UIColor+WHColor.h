//
//  UIColor+WHColor.h
//  WHTimePicker
//
//  Created by 吴浩 on 2017/6/9.
//  Copyright © 2017年 remember17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WHColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
