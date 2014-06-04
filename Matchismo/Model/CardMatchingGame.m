//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSInteger recentScore;
@property (nonatomic, readwrite) BOOL mismatchOccurred;
@property (nonatomic, strong, readwrite) NSMutableArray *attemptedMatchedCards;

@property (nonatomic, strong) Deck *deck;
@property (nonatomic) NSInteger numCardsInPlay;
@end

@implementation CardMatchingGame

- (void)setMode:(NSInteger)mode
{
    if (mode < 2 || mode > 3) _mode = 2;
    else _mode = mode;
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
                self.numCardsInPlay++;
            } else {
                self = nil;
                break;
            }
        }
        self.deck = deck;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            self.attemptedMatchedCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [self.attemptedMatchedCards addObject:otherCard];
                    if ([self.attemptedMatchedCards count] == self.mode - 1) {
                        break;
                    }
                }
            }
            if ([self.attemptedMatchedCards count] == self.mode - 1) {
                int matchScore = [card match:self.attemptedMatchedCards];
                if (matchScore > 0) {
                    self.score += matchScore * MATCH_BONUS;
                    self.recentScore = self.score + matchScore * MATCH_BONUS;
                    self.mismatchOccurred = NO;
                    card.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.recentScore = MISMATCH_PENALTY;
                    self.mismatchOccurred = YES;
                }
                for (Card *otherCard in self.attemptedMatchedCards) {
                    otherCard.matched = (matchScore > 0) ? YES : NO;
                    otherCard.chosen = (matchScore > 0) ? YES : NO;
                }
            }
            [self.attemptedMatchedCards addObject:card];
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (NSInteger)numberOfCardsInPlay
{
    return self.numCardsInPlay;
}

- (void)decrementCardsInPlay
{
    self.numCardsInPlay--;
}

- (void)removeCardFromCards:(Card *)card
{
    [self.cards removeObject:card];
}

- (NSArray *)addCardsIntoPlay:(NSInteger)numCardsToAdd
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int i = 0; i < numCardsToAdd; i++) {
        Card *card = [self.deck drawRandomCard];
        if (!card) return cards;
        [self.cards addObject:card];
        [cards addObject:card];
        self.numCardsInPlay++;
    }
    return cards;
}

@end
