//
//  NSString+WHString.m
//  WHCategory
//
//  Created by 吴浩 on 2017/2/7.
//  Copyright © 2017年 wuhao. All rights reserved.
//

#import "NSString+WHString.h"

@implementation NSString (WHString)

- (NSString*)substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight
{
    NSRange rangeSub;
    NSString *strSub;
    
    NSRange range;
    range = [self rangeOfString:strLeft options:0];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.location = range.location + range.length;
    
    range.location = rangeSub.location;
    range.length = [self length] - range.location;
    range = [self rangeOfString:strRight options:0 range:range];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.length = range.location - rangeSub.location;
    strSub = [[self substringWithRange:rangeSub] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return strSub;
}

@end
