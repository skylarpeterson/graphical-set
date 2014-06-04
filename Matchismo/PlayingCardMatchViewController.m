//
//  PlayingCardMatchViewController.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/17/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "PlayingCardMatchViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface PlayingCardMatchViewController ()
@property (nonatomic) NSInteger cardsPerRow;
@property (nonatomic) NSInteger cardsPerCol;
@end

@implementation PlayingCardMatchViewController

#define NUM_CARDS 16

- (void)setup
{
    if (self.cardSuperView.frame.size.width > self.cardSuperView.frame.size.height) {
        self.cardsPerRow = 8;
        self.cardsPerCol = 2;
    } else {
        self.cardsPerRow = 4;
        self.cardsPerCol = 4;
    }
    NSInteger cellWidth = self.cardSuperView.bounds.size.width / self.cardsPerRow;
    NSInteger cellHeight = self.cardSuperView.bounds.size.height / self.cardsPerCol;
    [super setMode:2];
    
    for (int cardIndex = 0; cardIndex < NUM_CARDS; cardIndex++) {
        NSInteger row = cardIndex / self.cardsPerRow;
        NSInteger col = cardIndex % self.cardsPerRow;
        CGRect cardFrame = CGRectMake(self.cardSuperView.bounds.origin.x + cellWidth * col + self.view.bounds.size.width, self.cardSuperView.bounds.origin.y + cellHeight * row, cellWidth, cellHeight);
        PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardFrame];
        cardView.backgroundColor = [UIColor clearColor];
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardIndex];
        cardView.suit = card.suit;
        cardView.rank = card.rank;
        cardView.faceUp = NO;
        [self.cardViews insertObject:cardView atIndex:cardIndex];
    }
    
    [super setup];
}

- (NSInteger)numCardsInDeck
{
    return NUM_CARDS;
}

- (Deck *)createDeck
{
    self.deck = [[PlayingCardDeck alloc] init];
    return self.deck;
}

- (void)setVisibilityForCard:(PlayingCard *)card WithView:(PlayingCardView *)view
{
    if (card.isChosen) {
        if (view.faceUp == NO) {
            [UIView transitionWithView:view
                              duration:.25
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                view.faceUp = YES;
                            }
                            completion:nil];
        }
        view.faceUp = YES;
    } else {
        if(view.faceUp == YES) {
            [UIView transitionWithView:view
                              duration:.25
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                view.faceUp = NO;
                            }
                            completion:nil];
        }
        view.faceUp = NO;
    }
}

- (void)handleMatch:(PlayingCardView *)cardView
{
    cardView.alpha = 0.5;
}

@end
