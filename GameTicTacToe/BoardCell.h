//
//  BoardCell.h
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
@interface BoardCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, assign) PlayerType playerType;
@end
