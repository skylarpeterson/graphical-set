//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Skylar Peterson on 9/26/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *cardSuperView;

- (void)setMode:(NSInteger)mode;
- (void)setup;
- (void)cardTapped:(UITapGestureRecognizer *)gestureRecognizer;

@end
