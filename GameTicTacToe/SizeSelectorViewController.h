//
//  SizeSelectorViewController.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeSelectorViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField * txtSize;
-(IBAction)didTapProceed:(id)sender;
@end
