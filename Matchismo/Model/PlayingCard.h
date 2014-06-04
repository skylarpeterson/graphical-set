//
//  PlayingCard.h
//  Matchismo
//
//  Created by Skylar Peterson on 9/27/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
