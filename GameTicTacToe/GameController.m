//
//  GameController.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "GameController.h"
#import "ApplicationModel.h"
@interface GameController()
{
    ApplicationModel * mApplicationModel;
}
@end

@implementation GameController
- (instancetype)init
{
    self = [super init];
    if (self) {
        mApplicationModel = [ApplicationModel sharedInstance];
    }
    return self;
}

+ (GameController*)sharedInstance
{
    static GameController * gameController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (gameController == nil) {
            gameController = [[GameController alloc]init];
        }
    });
    return gameController;
}

- (void)gameTurnPlayed:(NSString *)turn withPlayer:(PlayerType)player
{
    [mApplicationModel.gameState setValue:[NSNumber numberWithInt:player] forKey:turn];
    GameResult result = [self checkResult:player];
    
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(gameResult:withPlayer:)]) {
        [self.delegate gameResult:result withPlayer:player];
    }
}

- (void)initiateNextComputerMove
{
    NSNumber * anyCell;
    id randomKey;
    NSArray* allKeys = [mApplicationModel.gameState allKeys];
    randomKey = allKeys[arc4random_uniform([allKeys count])];
    anyCell = mApplicationModel.gameState[randomKey];
    
    while (anyCell.integerValue != PlayerTypeNone) {
        randomKey = allKeys[arc4random_uniform([allKeys count])];
        anyCell = mApplicationModel.gameState[randomKey];
    }
    
    [self gameTurnPlayed:randomKey withPlayer:PlayerTypeComputer];
}

#pragma mark private method
-(GameResult)checkResult:(PlayerType)playerType
{
    BOOL continueFlag = NO;
    for (int p = 0; p<mApplicationModel.sizeBoard; p++) {// Checking Rows
        BOOL playerWon = YES;
        BOOL computerWon = YES;
        for (int k = 0; k<mApplicationModel.sizeBoard; k++) {
            NSNumber *number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%d%d",p,k]];
            if (number.integerValue == PlayerTypeHuman) {
                computerWon = NO;
            }
            else if (number.integerValue == PlayerTypeComputer) {
                playerWon = NO;
            }
            else if (number.integerValue == PlayerTypeNone)
            {
                playerWon = computerWon = NO;
                continueFlag = YES;
            }
        }
        if (playerWon) {
            if (playerType == PlayerTypeHuman) {
                return Won;
            }
            return Lost;
        }
        else if (computerWon)
        {
            if (playerType == PlayerTypeHuman) {
                return Lost;
            }
            return Won;
        }
    }
    
    
    for (int p = 0; p<mApplicationModel.sizeBoard; p++) {// Checking Columns
        BOOL playerWon = YES;
        BOOL computerWon = YES;
        for (int k = 0; k<mApplicationModel.sizeBoard; k++) {
            NSNumber *number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%d%d",k,p]];
            if (number.integerValue == PlayerTypeHuman) {
                computerWon = NO;
            }
            else if (number.integerValue == PlayerTypeComputer) {
                playerWon = NO;
            }
            else if (number.integerValue == PlayerTypeNone)
            {
                playerWon = computerWon = NO;
                continueFlag = YES;
            }
        }
        if (playerWon) {
            if (playerType == PlayerTypeHuman) {
                return Won;
            }
            return Lost;
        }
        else if (computerWon)
        {
            if (playerType == PlayerTypeHuman) {
                return Lost;
            }
            return Won;
        }
    }
  
    BOOL playerWon = YES;
    BOOL computerWon = YES;
    for (int p = 0; p<mApplicationModel.sizeBoard; p++) {// Checking Diagonals

                NSNumber *number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%d%d",p,p]];
                if (number.integerValue == PlayerTypeHuman) {
                    computerWon = NO;
                }
                else if (number.integerValue == PlayerTypeComputer) {
                    playerWon = NO;
                }
                else if (number.integerValue == PlayerTypeNone)
                {
                    playerWon = computerWon = NO;
                    continueFlag = YES;
                }
        
    }
    if (playerWon) {
        if (playerType == PlayerTypeHuman) {
            return Won;
        }
        return Lost;
    }
    else if (computerWon)
    {
        if (playerType == PlayerTypeHuman) {
            return Lost;
        }
        return Won;
    }

    
    playerWon = YES;
    computerWon = YES;
    for (int p = 0; p<mApplicationModel.sizeBoard; p++) {// Checking Diagonals
        
        NSNumber *number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%d%u",p,mApplicationModel.sizeBoard-p-1]];
        if (number.integerValue == PlayerTypeHuman) {
            computerWon = NO;
        }
        else if (number.integerValue == PlayerTypeComputer) {
            playerWon = NO;
        }
        else if (number.integerValue == PlayerTypeNone)
        {
            playerWon = computerWon = NO;
            continueFlag = YES;
        }
        
    }
    if (playerWon) {
        if (playerType == PlayerTypeHuman) {
            return Won;
        }
        return Lost;
    }
    else if (computerWon)
    {
        if (playerType == PlayerTypeHuman) {
            return Lost;
        }
        return Won;
    }

    
    

    if (continueFlag == YES) {
        return Continue;
    }
    else
    {
        return Drawn;
    }
}

@end
