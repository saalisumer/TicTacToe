//
//  ApplicationModel.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameController.h"

@interface ApplicationModel : NSObject
@property (nonatomic, assign) NSUInteger sizeBoard;
+ (ApplicationModel* )sharedInstance;
- (void)clearSession;
- (void)logGameResult:(GameResult)result withLastTurn:(PlayerType)player;
- (NSMutableDictionary*)getGameResultHistory;
- (PlayerType)nextTurnPlayer;
- (void)setNextPlayer:(PlayerType)player;

- (NSNumber*)gameStateForRow:(NSUInteger)row column:(NSUInteger)column;
- (void)gameTurnPlayed:(NSUInteger)row column:(NSUInteger)column withPlayer:(PlayerType)player;
- (NSDictionary*)randomKeyForTurn;
@end
