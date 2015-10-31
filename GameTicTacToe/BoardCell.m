//
//  BoardCell.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "Constants.h"
#import "BoardCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ApplicationModel.h"

@implementation BoardCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    
}

-(void)setPlayerType:(PlayerType)playerType
{
    _playerType = playerType;
    if (playerType == PlayerTypeNone) {
        self.imageView.image = nil;
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",(int)playerType]];
    }
}

-(NSString *)reuseIdentifier
{
    return kBOARDCELLIdentifier;
}
@end
