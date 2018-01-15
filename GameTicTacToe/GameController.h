//
//  GameController.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@protocol GameDelegate <NSObject>

-(void)gameResult:(GameResult)gameResult withPlayer:(PlayerType)playerType;

@end

@interface GameController : NSObject
@property (nonatomic, weak) id<GameDelegate> delegate;
+ (GameController*)sharedInstance;
- (void)initiateNextComputerMove;
- (void)gameTurnPlayedWithRow:(NSUInteger)row andColumn:(NSUInteger)column withPlayer:(PlayerType)player;
@end
