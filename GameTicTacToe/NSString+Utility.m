//
//  NSString+Utility.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
- (BOOL)isInteger{
    if([self intValue] != 0) {
        return true;
    } else if([self isEqualToString:@"0"]) {
        return true;
    } else {
        return false;
    }
}
@end
