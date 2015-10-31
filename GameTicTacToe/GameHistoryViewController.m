//
//  GameHistoryViewController.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/31/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "GameHistoryViewController.h"
#import "ApplicationModel.h"
#import "Constants.h"

@interface GameHistoryViewController ()
{
    ApplicationModel * mApplicationModel;
}

@end

@implementation GameHistoryViewController

- (void)viewDidLoad {
    mApplicationModel = [ApplicationModel sharedInstance];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self validateProperties];
}

-(void)validateProperties
{
    NSMutableDictionary* gameHistoryResult = [mApplicationModel getGameResultHistory];
    NSUInteger wins = [[gameHistoryResult valueForKey:kResultWins] integerValue];
    NSUInteger losses = [[gameHistoryResult valueForKey:kResultLosses] integerValue];
    NSUInteger draws = [[gameHistoryResult valueForKey:kResultDraws] integerValue];
    self.lblWins.text = [NSString stringWithFormat:@"Wins: %d",wins];
    self.lblLosses.text = [NSString stringWithFormat:@"Losses: %d",losses];
    self.lblDraws.text = [NSString stringWithFormat:@"Draws: %d",draws];
    self.lblTotalCompletedGames.text = [NSString stringWithFormat:@"Total: %d", wins+losses+draws];
}


@end
