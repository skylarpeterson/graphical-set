//
//  SetCard.h
//  Matchismo
//
//  Created by Skylar Peterson on 10/15/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong, readonly) NSAttributedString *cardContents;

- (SetCard *)initWithSign:(NSInteger)sign
                 andColor:(NSInteger)color
               andShading:(NSInteger)shading
                 andValue:(NSInteger)numSymbols;

@property (nonatomic, readonly) NSInteger sign;
@property (nonatomic, readonly) NSInteger color;
@property (nonatomic, readonly) NSInteger shading;
@property (nonatomic, readonly) NSUInteger numSymbols;

+ (NSInteger)numSigns;
+ (NSInteger)numColors;
+ (NSInteger)numShading;
+ (NSInteger)maxNumSymbols;

@end
