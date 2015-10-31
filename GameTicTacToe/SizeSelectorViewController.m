//
//  SizeSelectorViewController.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "SizeSelectorViewController.h"
#import "TicTacToeGameViewController.h"
#import "NSString+Utility.h"
#import "ApplicationModel.h"
#import "Constants.h"

@interface SizeSelectorViewController ()

@end

@implementation SizeSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didTapProceed:(id)sender
{
    if ([self.txtSize.text isInteger] && self.txtSize.text.integerValue >= kMinBoardSize && self.txtSize.text.integerValue <= kMaxBoardSize)
    {
        ApplicationModel * appModel = [ApplicationModel sharedInstance];
        appModel.sizeBoard = self.txtSize.text.integerValue;
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TicTacToeGameViewController * ticTacToeVC = [storyboard instantiateViewControllerWithIdentifier:kGameBoardVCIdentifier];
        [self.navigationController pushViewController:ticTacToeVC animated:YES];
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat: @"Please enter a number between %d and %d",kMinBoardSize,kMaxBoardSize] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
