//
//  ApplicationModel.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "ApplicationModel.h"
#import "Constants.h"

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
    [self initializeBoard:_sizeBoard];
}

- (void)logGameResult:(GameResult)result withLastTurn:(PlayerType)player
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (result == Won) {
        NSNumber * number = [userDefaults valueForKey:kResultWins];
        if (number == nil) {
            number = [NSNumber numberWithInt:1];
        }
        else
        {
            number = [NSNumber numberWithInteger:(number.integerValue + 1)];
        }
        [userDefaults setValue:number forKey:kResultWins];
        [userDefaults setValue:[NSNumber numberWithInteger:PlayerTypeHuman] forKey:kKeyNextTurn];
    }
    else if (result == Lost) {
        NSNumber * number = [userDefaults valueForKey:kResultLosses];
        if (number == nil) {
            number = [NSNumber numberWithInt:1];
        }
        else
        {
            number = [NSNumber numberWithInteger:(number.integerValue + 1)];
        }
        [userDefaults setValue:number forKey:kResultLosses];
        [userDefaults setValue:[NSNumber numberWithInteger:PlayerTypeComputer] forKey:kKeyNextTurn];
    }
    else if (result == Drawn) {
        NSNumber * number = [userDefaults valueForKey:kResultDraws];
        if (number == nil) {
            number = [NSNumber numberWithInt:1];
        }
        else
        {
            number = [NSNumber numberWithInteger:(number.integerValue + 1)];
        }
        [userDefaults setValue:number forKey:kResultDraws];
        [userDefaults setValue:[NSNumber numberWithInteger:player] forKey:kKeyNextTurn];
    }
    
    
    [userDefaults synchronize];
}

- (NSMutableDictionary*)getGameResultHistory
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
    NSNumber * wins = [userDefaults valueForKey:kResultWins];
    NSNumber * losses = [userDefaults valueForKey:kResultLosses];
    NSNumber * draws = [userDefaults valueForKey:kResultDraws];
    
    if (!wins) {
        wins = [NSNumber numberWithInt:0];
    }
    
    if (!losses) {
        losses = [NSNumber numberWithInt:0];
    }
    
    if (!draws) {
        draws = [NSNumber numberWithInt:0];
    }
    
    [dictionary setValue:wins forKey:kResultWins];
    [dictionary setValue:losses forKey:kResultLosses];
    [dictionary setValue:draws forKey:kResultDraws];
    return dictionary;
}

- (PlayerType)nextTurnPlayer
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber * nextTurnPlayer = [userDefaults valueForKey:kKeyNextTurn];

    if (!nextTurnPlayer) {
        return PlayerTypeHuman;
    }
    else
    {
        return (PlayerType)nextTurnPlayer.integerValue;
    }
}

- (void)setNextPlayer:(PlayerType)player
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithInteger:player] forKey:kKeyNextTurn];
    [userDefaults synchronize];
}
@end
