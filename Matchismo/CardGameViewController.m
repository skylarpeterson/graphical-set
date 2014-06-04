//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Skylar Peterson on 9/26/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSInteger mode;
@property (nonatomic) BOOL matchOccurred;
@end

@implementation CardGameViewController

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numCardsInDeck]
                                                  usingDeck:[self createDeck]];
        _game.mode = self.mode;
    }
    return _game;
}

- (Deck *)createDeck { return nil; }
- (NSInteger)numCardsInDeck { return 0; }

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.class == [UITapGestureRecognizer class]) {
        Card *card = [self.game cardAtIndex:[self.cardViews indexOfObject:gestureRecognizer.view]];
        if (card.isMatched) {
            return NO;
        }
    }
    return YES;
}

- (void)cardTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    int chosenIndex = [self.cardViews indexOfObject:gestureRecognizer.view];
    [self.game chooseCardAtIndex:chosenIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIView *cardView in self.cardViews) {
        Card *card = [self.game cardAtIndex:[self.cardViews indexOfObject:cardView]];
        [self setVisibilityForCard:card WithView:cardView];
        if (card.isMatched) {
            [self handleMatch:cardView];
            self.matchOccurred = YES;
        } else {
            cardView.alpha = 1.0;
        }
    }
    if (self.matchOccurred) {
        [self performSelector:@selector(matchesDone) withObject:self afterDelay:1.0];
        self.matchOccurred = NO;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setVisibilityForCard:(Card *)card WithView:(UIView *)view { }
- (void)handleMatch:(UIView *)cardView { }
- (void)matchesDone { }

- (IBAction)resetGame:(id)sender
{
    self.game = nil;
    self.deck = nil;
    for (UIView *cardView in self.cardViews) {
        [UIView transitionWithView:cardView
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            cardView.frame = CGRectMake(0 - 2*cardView.frame.size.width, cardView.frame.origin.y, cardView.frame.size.width, cardView.frame.size.height);
                        }
                        completion:nil];
    }
    self.cardViews = nil;
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    for (UIView *card in self.cardViews) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(cardTapped:)];
        [card addGestureRecognizer:tapGesture];
        [self.cardSuperView addSubview:card];
        [UIView transitionWithView:card
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            card.frame = CGRectMake(card.frame.origin.x - self.view.bounds.size.width, card.frame.origin.y, card.frame.size.width, card.frame.size.height);
                        }
                        completion:nil];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", self.game.score];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (UIView *view in self.cardSuperView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.cardViews) {
        [view removeFromSuperview];
    }
    [self setup];
}

@end
