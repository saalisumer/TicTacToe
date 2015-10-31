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
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (number.integerValue == PlayerTypeNone) {
        return YES;
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.item/mApplicationModel.sizeBoard;
    long column = indexPath.item%mApplicationModel.sizeBoard;
    [mGameController gameTurnPlayed:[NSString stringWithFormat:@"%lu%lu",row,column] withPlayer:PlayerTypeHuman];
    [self.collectionView reloadData];
}

#pragma mark Interface orientation change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
          }];
}

#pragma mark GameDelegate
-(void)gameResult:(GameResult)gameResult withPlayer:(PlayerType)playerType
{
    GameResult userGameResult;
    if ((gameResult == Won && playerType == PlayerTypeHuman) || (gameResult == Lost && playerType == PlayerTypeComputer)) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You Won" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        userGameResult = Won;
    }
    else if (gameResult == Drawn) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Game Drawn" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        userGameResult = Drawn;
    }
    else if (gameResult == Continue)
    {
        userGameResult = Continue;
        if (playerType == PlayerTypeHuman) {
            [mGameController initiateNextComputerMove];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Game Lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        userGameResult = Lost;
    }
    
    if (userGameResult != Continue) {//log completed games
        [mApplicationModel logGameResult:userGameResult];
    }
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [mApplicationModel clearSession];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
