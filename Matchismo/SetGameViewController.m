//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/17/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCarView.h"

@interface SetGameViewController ()
@property (nonatomic) NSInteger cardsPerRow;
@end

@implementation SetGameViewController

#define NUM_CARDS_DEFAULT 12

- (void)setup
{
    [super setMode:3];
    for (int cardIndex = 0; cardIndex < [self.game numberOfCardsInPlay]; cardIndex++) {
        if (self.cardSuperView.frame.size.width > self.cardSuperView.frame.size.height) {
            self.cardsPerRow = 6;
        } else {
            self.cardsPerRow = 3;
        }
        CGFloat cellWidth = self.cardSuperView.frame.size.width / self.cardsPerRow;
        CGFloat cellHeight = self.cardSuperView.frame.size.height / ([self.game numberOfCardsInPlay] / self.cardsPerRow);
        NSInteger row = cardIndex / self.cardsPerRow;
        NSInteger col = cardIndex % self.cardsPerRow;
        CGRect cardFrame = CGRectMake((cellWidth * col) + self.view.bounds.size.width, cellHeight * row, cellWidth, cellHeight);
        SetCarView *cardView = [[SetCarView alloc] initWithFrame:cardFrame];
        cardView.backgroundColor = [UIColor clearColor];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardIndex];
        cardView = [self setupCardView:cardView WithCard:card];
        [self.cardViews addObject:cardView];
    }
    
    [super setup];
}

- (SetCarView *)setupCardView:(SetCarView *)cardView WithCard:(SetCard *)card
{
    cardView.sign = card.sign;
    cardView.shading = card.shading;
    cardView.numSymbols = card.numSymbols;
    if (card.color == 1) {
        cardView.color = [UIColor colorWithRed:1.0f green:69.0f/255.0f blue:0.0f alpha:1.0f];
    } else if (card.color == 2) {
        cardView.color = [UIColor colorWithRed:50.0f/255.0f green:205.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    } else {
        cardView.color = [UIColor colorWithRed:147.0f/255.0f green:112.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    }
    return cardView;
}

- (NSInteger)numCardsInDeck
{
    return NUM_CARDS_DEFAULT;
}

- (Deck *)createDeck
{
    self.deck = [[SetCardDeck alloc] init];
    return self.deck;
}

- (void)setVisibilityForCard:(SetCard *)card WithView:(SetCarView *)view
{
    if (card.isChosen) {
        view.selected = YES;
    } else {
        view.selected = NO;
    }
}

- (void)handleMatch:(SetCarView *)cardView
{
    if (cardView.alpha == 0.0) {
        return;
    }
    [UIView transitionWithView:cardView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:^ {
                        cardView.alpha = 0.0;
                        cardView.matched = YES;
                    }
                    completion:^(BOOL finished){
                        [self.game decrementCardsInPlay];
                    }];
    [self animateCardPositions:cardView];
}

- (void)animateCardPositions:(SetCarView *)cardView
{
    NSInteger startIndex = [self.cardViews indexOfObject:cardView] + 1;
    CGRect moveTo = cardView.frame;
    CGRect moveFrom;
    for (NSInteger i = startIndex; i < [self.cardViews count]; i++) {
        SetCarView *nextCardView = [self.cardViews objectAtIndex:i];
        moveFrom = nextCardView.frame;
        [UIView transitionWithView:nextCardView
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            nextCardView.frame = moveTo;
                        }
                        completion:nil];
        moveTo = moveFrom;
    }
}

- (void)matchesDone
{
    [self adjustCardHeights];
}

- (IBAction)addCards:(id)sender
{
    NSArray *cards = [self.game addCardsIntoPlay:3];
    [self adjustCardHeights];
    CGFloat cellWidth = self.cardSuperView.frame.size.width / self.cardsPerRow;
    CGFloat cellHeight = self.cardSuperView.frame.size.height / ([self.game numberOfCardsInPlay] / self.cardsPerRow);
    NSMutableArray *newCardViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i++) {
        NSInteger col = i % self.cardsPerRow;
        SetCarView *cardView = [[SetCarView alloc] initWithFrame:CGRectMake(self.cardSuperView.frame.origin.x + cellWidth * col, self.view.frame.size.height, cellWidth, cellHeight)];
        cardView.backgroundColor = [UIColor clearColor];
        SetCard *card = (SetCard *)[cards objectAtIndex:i];
        cardView = [self setupCardView:cardView WithCard:card];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(cardTapped:)];
        [cardView addGestureRecognizer:tapGesture];
        [self.view addSubview:cardView];
        [newCardViews addObject:cardView];
    }
    [self.view setNeedsDisplay];
    NSInteger row = ([self.game numberOfCardsInPlay] - 1) / self.cardsPerRow;
    for (SetCarView *cardView in newCardViews) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cardView.frame = CGRectMake(cardView.frame.origin.x, self.cardSuperView.frame.origin.y + cellHeight * row, cardView.frame.size.width, cardView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.cardViews addObject:cardView];
                             }
                         }];
    }
}

- (void)adjustCardHeights
{
    NSInteger row = 0;
    NSInteger rowCount = 0;
    for (SetCarView *cardView in self.cardViews) {
        if (cardView.matched) continue;
        NSInteger numCardsInPlay = [self.game numberOfCardsInPlay];
        CGFloat newHeight = self.cardSuperView.frame.size.height / (numCardsInPlay / self.cardsPerRow);
        CGFloat yDisplacement = newHeight - cardView.frame.size.height;
        [UIView transitionWithView:cardView
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            cardView.frame = CGRectMake(cardView.frame.origin.x, cardView.frame.origin.y + (yDisplacement * row), cardView.frame.size.width, newHeight);
                        }
                        completion:nil];
        rowCount++;
        if (rowCount % self.cardsPerRow == 0) {
            row++;
        }
    }
}

- (void)cardTapped:(UITapGestureRecognizer *)gesture { [super cardTapped:gesture]; }

@end
