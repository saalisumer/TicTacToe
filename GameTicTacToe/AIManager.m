//
//  AIManager.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 1/14/18.
//  Copyright © 2018 Saalis Umer. All rights reserved.
//

#import "AIManager.h"
#import "ApplicationModel.h"

@implementation AIManager
+ (AIManager* )sharedInstance
{
    static AIManager * aiManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (aiManager == nil) {
            aiManager = [[AIManager alloc]init];
        }
    });
    return aiManager;
}

- (NSArray*)actionsForState:(NSArray<NSArray*>*)state
{
    NSUInteger sizeBoard = [[ApplicationModel sharedInstance]sizeBoard];
    NSMutableArray * actions = [[NSMutableArray alloc]initWithCapacity:sizeBoard*sizeBoard];
    for (NSUInteger x = 0; x < sizeBoard; x++) {
        for (NSUInteger y = 0; y < sizeBoard; y++) {
            if([state[x][y] integerValue] == PlayerTypeNone)
            {
                [actions addObject:@{@"row":@(x),@"column":@(y)}];
            }
        }
    }
    return actions;
}

- (NSArray<NSArray*>*)resultForStateForAction:(NSDictionary*)action onState:(NSArray<NSArray*>*)state withPlayer:(PlayerType)playerType
{
    NSMutableArray * arrayMutable = [NSMutableArray arrayWithCapacity:state.count];
    for (NSArray * array in state) {
        [arrayMutable addObject:[array mutableCopy]];
    }
    
    NSUInteger row = [action[@"row"]integerValue];
    NSUInteger column = [action[@"column"]integerValue];
    arrayMutable[row][column] = @(playerType);
    return [arrayMutable copy];
}

- (NSInteger)utility:(NSArray<NSArray*>*)state
{
    GameResult result = [self checkResultForState:state];
    if (result == Won)
    {
        return 10;
    }
    else if (result == Lost)
    {
        return -10;
    }
    else if (result == Drawn)
    {
        return 0;
    }
    else
    {
        return -1;
    }
}

-(GameResult)checkResultForState:(NSArray<NSArray*>*)state
{
    NSUInteger sizeBoard = state.count;
    BOOL continueGame = false;
    NSUInteger diagonalOneProduct = 1;
    NSUInteger diagonalTwoProduct = 1;
    
    NSUInteger victoryPlayer = pow(PlayerTypeHuman,sizeBoard);
    NSUInteger victoryComputer = pow(PlayerTypeComputer,sizeBoard);
    for(int i =0; i<sizeBoard; i++)
    {
        NSUInteger productRow = 1;
        NSUInteger productColumn = 1;
        for(int j =0; j<sizeBoard; j++)
        {
            productRow = productRow * [state[i][j] integerValue];
            productColumn = productColumn * [state[j][i] integerValue];
        }
        
        diagonalOneProduct = diagonalOneProduct * [state[i][i] integerValue];
        diagonalTwoProduct = diagonalTwoProduct * [state[i][sizeBoard - i -1] integerValue];
        
        if(productRow == victoryComputer || productColumn == victoryComputer)
        {
            return Won;
        }
        else if (productRow == victoryPlayer || productColumn == victoryPlayer)
        {
            return Lost;
        }
        else if (productColumn == 0 || productRow == 0)
        {
            continueGame = true;
        }
    }
    
    if(diagonalOneProduct == victoryComputer || diagonalTwoProduct == victoryComputer)
    {
        return Won;
    }
    else if(diagonalOneProduct == victoryPlayer || diagonalTwoProduct == victoryPlayer)
    {
        return Lost;
    }

    if (continueGame) {
        return Continue;
    }
    else
    {
        return Drawn;
    }
}

#pragma mark - Minimax methods
//-(NSDictionary*)minimaxDecision:(NSArray<NSArray*>*)state forPlayerType:(PlayerType)playerType
//{
//
//}
//
//-(NSInteger)minimaxValueForState:(NSArray<NSArray*>*)state forPlayerType:(PlayerType)playerType
//{
//    NSInteger value = [self utility:state];
//    if (value != 0) {
//        return value;
//    }
//
//    NSArray * actions = [self actionsForState:state];
//    NSInteger index = -1;
//
//    if (playerType == PlayerTypeComputer)
//    {
//        NSInteger resultMax = 0;
//        for(NSDictionary* action in actions)
//        {
//            NSInteger result = [self minimaxValueForState:[self resultForStateForAction:action onState:state withPlayer:PlayerTypeComputer] forPlayerType:PlayerTypeHuman];
//            if(result > resultMax || index == -1)
//            {
//                index = [actions indexOfObject:action];
//                resultMax = result;
//            }
//        }
//        return resultMax;
//    }
//    else if (playerType == PlayerTypeHuman)
//    {
//        NSInteger resultMin = 0;
//        for(NSDictionary* action in actions)
//        {
//            NSInteger result = [self minimaxValueForState:[self resultForStateForAction:action onState:state withPlayer:PlayerTypeHuman] forPlayerType:PlayerTypeComputer];
//            if(result < resultMin || index == -1)
//            {
//                index = [actions indexOfObject:action];
//                resultMin = result;
//            }
//        }
//        return resultMin;
//    }
//}


-(NSDictionary*)minimaxDecision:(NSArray<NSArray*>*)state
{
    NSArray * actions = [self actionsForState:state];
    NSUInteger maxIndex = 0;
    NSInteger value = 0;
    for (int i = 0; i < actions.count; i++)
    {
        NSInteger newValue = [self minValue:[self resultForStateForAction:actions[i] onState:state withPlayer:PlayerTypeComputer]];
        if(i == 0)
        {
            value = newValue;
            maxIndex = i;
        }
        else if (newValue > value) {
            value = newValue;
            maxIndex = i;
        }
        NSLog(@"action %@ --- value: %ld",actions[i],newValue);
    }

    return actions[maxIndex];
}

-(NSInteger)maxValue:(NSArray<NSArray*>*)state
{
    NSInteger value = [self utility:state];
    if (value != -1) {
        return value;
    }
    
    value = INT_MIN;
    NSArray * actions = [self actionsForState:state];
    for (NSDictionary * action in actions) {
        id stateResult = [self resultForStateForAction:action onState:state withPlayer:PlayerTypeComputer];
        value = MAX(value,[self minValue:stateResult]);
    }
    return value;
}

-(NSInteger)minValue:(NSArray<NSArray*>*)state
{
    NSInteger value = [self utility:state];
    if (value != -1) {
        return value;
    }
    
    value = INT_MAX;
    NSArray * actions = [self actionsForState:state];
    for (NSDictionary * action in actions) {
        id stateResult = [self resultForStateForAction:action onState:state withPlayer:PlayerTypeHuman];
        value = MIN(value,[self maxValue:stateResult]);
    }
    return value;
}


@end
