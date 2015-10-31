//
//  ApplicationModel.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "ApplicationModel.h"
#import "GameController.h"

@implementation ApplicationModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeAll];
    }
    return self;
}

-(void)initializeAll
{
    _gameState = [[NSMutableDictionary alloc]init];
}

-(void)setSizeBoard:(NSUInteger)sizeBoard
{
    _sizeBoard = sizeBoard;
    [self initializeBoard:sizeBoard];
}

- (void)initializeBoard:(NSUInteger)sizeBoard
{
    for (int k = 0; k<sizeBoard; k++) {
        for (int p =0; p<sizeBoard; p++) {
            [_gameState setValue:[NSNumber numberWithInteger:PlayerTypeNone] forKey:[NSString stringWithFormat:@"%d%d",k,p]];
        }
    }
}

+ (ApplicationModel* )sharedInstance
{
    static ApplicationModel * appModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appModel == nil) {
            appModel = [[ApplicationModel alloc]init];
        }
    });
    return appModel;
}
- (void)clearSession
{
    [self initializeAll];
}
@end
