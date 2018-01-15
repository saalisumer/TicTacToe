//
//  Enums.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 1/14/18.
//  Copyright © 2018 Saalis Umer. All rights reserved.
//

#ifndef Enums_h
#define Enums_h
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

#endif /* Enums_h */
