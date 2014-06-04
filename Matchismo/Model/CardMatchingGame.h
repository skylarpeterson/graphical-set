//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Skylar Peterson on 10/5/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (NSInteger)numberOfCardsInPlay;
- (void)decrementCardsInPlay;
- (NSArray *)addCardsIntoPlay:(NSInteger)numCardsToAdd;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSInteger mode;

@property (nonatomic, readonly) NSInteger recentScore;
@property (nonatomic, readonly) BOOL mismatchOccurred;
@property (nonatomic, strong, readonly) NSMutableArray *attemptedMatchedCards;

@end
