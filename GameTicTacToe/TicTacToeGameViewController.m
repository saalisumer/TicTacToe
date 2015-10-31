//
//  ViewController.m
//  GameTicTacToe
//
//  Created by Saalis Umer on 10/30/15.
//  Copyright (c) 2015 Saalis Umer. All rights reserved.
//

#import "TicTacToeGameViewController.h"
#import "ApplicationModel.h"
#import "BoardCell.h"
#import "Constants.h"
#import "GameController.h"

#define kAlertTagWon 101
#define kAlertTagLost 102
#define kAlertTagDrawn 103

@interface TicTacToeGameViewController ()<GameDelegate, UIAlertViewDelegate>
{
    ApplicationModel * mApplicationModel;
    GameController   * mGameController;
}
@end

@implementation TicTacToeGameViewController

- (void)viewDidLoad {
    mApplicationModel = [ApplicationModel sharedInstance];
    mGameController = [GameController sharedInstance];
    mGameController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"BoardCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kBOARDCELLIdentifier];
    [self validateLabel];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animateLabel) userInfo:nil repeats:YES];
    [self makeNextComputerMoveIfNeeded];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)animateLabel
{
    [UIView animateWithDuration:0.5 animations:^{
        self.lblPlayer.alpha = 0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.lblPlayer.alpha = 1;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self validateLabel];
    [self.collectionView reloadData];
}

-(void)validateLabel
{
    if (mApplicationModel.nextTurnPlayer == PlayerTypeHuman) {
        self.lblPlayer.text = kUserTurn;
    }
    else if (mApplicationModel.nextTurnPlayer == PlayerTypeComputer)
    {
        self.lblPlayer.text = kComputersTurn;
    }
}

#pragma mark UICollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mApplicationModel.sizeBoard * mApplicationModel.sizeBoard;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BoardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBOARDCELLIdentifier forIndexPath:indexPath];
    long row = indexPath.item/mApplicationModel.sizeBoard;
    long column = indexPath.item%mApplicationModel.sizeBoard;
    NSNumber * number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%lu%lu",row,column]];
    cell.playerType = (PlayerType)number.integerValue;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = collectionView.bounds.size.width/mApplicationModel.sizeBoard;
    return CGSizeMake(size,size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.item/mApplicationModel.sizeBoard;
    long column = indexPath.item%mApplicationModel.sizeBoard;
    NSNumber * number = [mApplicationModel.gameState valueForKey:[NSString stringWithFormat:@"%lu%lu",row,column]];
    if (number.integerValue == PlayerTypeNone && mApplicationModel.nextTurnPlayer == PlayerTypeHuman) {
        return YES;
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.item/mApplicationModel.sizeBoard;
    long column = indexPath.item%mApplicationModel.sizeBoard;
    [mGameController gameTurnPlayed:[NSString stringWithFormat:@"%lu%lu",row,column] withPlayer:PlayerTypeHuman];
}

#pragma mark Interface orientation change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self refresh];
    }];
}

#pragma mark GameDelegate
-(void)gameResult:(GameResult)gameResult withPlayer:(PlayerType)playerType
{
    GameResult userGameResult;
    if ((gameResult == Won && playerType == PlayerTypeHuman) || (gameResult == Lost && playerType == PlayerTypeComputer)) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You Won" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Restart",nil];
        alert.tag = kAlertTagWon;
        [alert show];
        userGameResult = Won;
    }
    else if (gameResult == Drawn) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Game Drawn" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Restart",nil];
        alert.tag = kAlertTagDrawn;
        [alert show];
        userGameResult = Drawn;
    }
    else if (gameResult == Continue)
    {
        [self makeNextComputerMoveIfNeeded];
        userGameResult = Continue;
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Game Lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Restart",nil];
        alert.tag = kAlertTagLost;
        [alert show];
        userGameResult = Lost;
    }
    
    
    if (userGameResult != Continue) {//log completed games
        [mApplicationModel logGameResult:userGameResult withLastTurn:playerType];
    }
    [self refresh];

}

-(void)makeNextComputerMoveIfNeeded
{
    if (mApplicationModel.nextTurnPlayer == PlayerTypeComputer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mGameController initiateNextComputerMove];
        });
    }
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [mApplicationModel clearSession];
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1)
    {
        [self refresh];
        [self makeNextComputerMoveIfNeeded];
    }
    
}
@end
