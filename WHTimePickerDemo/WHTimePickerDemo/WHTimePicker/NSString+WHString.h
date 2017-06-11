//
//  NSString+WHString.h
//  WHCategory
//  https://github.com/remember17/WHTimePicker
//  Created by 吴浩 on 2017/2/7.
//  Copyright © 2017年 wuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WHString)

/**
 根据整个字符串左边和右边的字符串吗,获得中间特定字符串
 @param strLeft 左边匹配字符串
 @param strRight 右边匹配的字符串
 */
- (NSString*)substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;

@end
