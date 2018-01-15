//
//  AIManager.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 1/14/18.
//  Copyright © 2018 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface AIManager : NSObject
+ (AIManager* )sharedInstance;
- (NSArray*)actionsForState:(NSArray<NSArray*>*)state;
- (NSArray<NSArray*>*)resultForStateForAction:(NSDictionary*)action onState:(NSArray<NSArray*>*)state withPlayer:(PlayerType)playerType;
- (NSDictionary*)minimaxDecision:(NSArray<NSArray*>*)state;
- (NSDictionary*)minimaxDecision:(NSArray<NSArray*>*)state forPlayerType:(PlayerType)playerType;
@end
