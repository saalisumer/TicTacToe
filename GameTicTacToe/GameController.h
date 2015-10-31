//
//  GameController.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PlayerType
{
    PlayerTypeNone = 0,
    PlayerTypeHuman = 1,
    PlayerTypeComputer = 2
}PlayerType;

typedef enum GameResult
{
    Won = 0,
    Lost = 1,
    Drawn = 2,
    Continue = 3
}GameResult;

@protocol GameDelegate <NSObject>

-(void)gameResult:(GameResult)gameResult withPlayer:(PlayerType)playerType;

@end

@interface GameController : NSObject
@property (nonatomic, weak) id<GameDelegate> delegate;
+ (GameController*)sharedInstance;
- (void)initiateNextComputerMove;
- (void)gameTurnPlayed:(NSString *)turn withPlayer:(PlayerType)player;
@end
