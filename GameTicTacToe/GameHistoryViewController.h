//
//  GameHistoryViewController.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/31/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameHistoryViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel * lblWins;
@property (nonatomic, weak) IBOutlet UILabel * lblLosses;
@property (nonatomic, weak) IBOutlet UILabel * lblDraws;
@property (nonatomic, weak) IBOutlet UILabel * lblTotalCompletedGames;
@end
