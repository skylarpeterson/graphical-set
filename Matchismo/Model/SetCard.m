//
//  SetCard.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/15/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SetCard.h"

@interface SetCard ()
@property (nonatomic, strong, readwrite) NSAttributedString *cardContents;

@property (nonatomic, readwrite) NSInteger sign;
@property (nonatomic, readwrite) NSInteger color;
@property (nonatomic, readwrite) NSInteger shading;
@property (nonatomic, readwrite) NSUInteger numSymbols;
@end

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int matchScore = 0;
    if ([otherCards count] == 2) {
        BOOL signs = [self compareSigns:otherCards];
        BOOL colors = [self compareColors:otherCards];
        BOOL shading = [self compareShading:otherCards];
        BOOL count = [self compareVal:otherCards];
        if (!signs && !colors && !shading && !count) {
            matchScore += 10;
        }
    }
    return matchScore;
}

- (BOOL)compareSigns:(NSArray *)otherCards
{
    SetCard *first = [otherCards firstObject];
    SetCard *second = [otherCards objectAtIndex:1];
    if (self.sign == first.sign && self.sign == second.sign) return NO;
    if (self.sign  == first.sign) return YES;
    if (self.sign == second.sign) return YES;
    if (first.sign == second.sign) return YES;
    return NO;
}

- (BOOL)compareColors:(NSArray *)otherCards
{
    SetCard *first = [otherCards firstObject];
    SetCard *second = [otherCards objectAtIndex:1];
    if (self.color == first.color && self.color == second.color) return NO;
    if (self.color == first.color) return YES;
    if (self.color == second.color) return YES;
    if (first.color == second.color) return YES;
    return NO;
}

- (BOOL)compareShading:(NSArray *)otherCards
{
    SetCard *first = [otherCards firstObject];
    SetCard *second = [otherCards objectAtIndex:1];
    if (self.shading == first.shading && self.shading == second.shading) return NO;
    if (self.shading == first.shading) return YES;
    if (self.shading == second.shading) return YES;
    if (first.shading == second.shading) return YES;
    return NO;
}

- (BOOL)compareVal:(NSArray *)otherCards
{
    SetCard *first = [otherCards firstObject];
    SetCard *second = [otherCards objectAtIndex:1];
    if (self.numSymbols == first.numSymbols && self.numSymbols == second.numSymbols) return NO;
    if (self.numSymbols == first.numSymbols) return YES;
    if (self.numSymbols == second.numSymbols) return YES;
    if (first.numSymbols == second.numSymbols) return YES;
    return NO;
}

- (SetCard *)initWithSign:(NSInteger)sign andColor:(NSInteger)color andShading:(NSInteger)shading andValue:(NSInteger)numSymbols
{
    self = [super init];
    if (self) {
        self.sign = sign;
        self.color = color;
        self.shading = shading;
        self.numSymbols = numSymbols;
    }
    return self;
}

+ (NSInteger)numSigns
{
    return 3;
}

+ (NSInteger)numColors
{
    return 3;
}

+ (NSInteger)numShading
{
    return 3;
}

+ (NSInteger)maxNumSymbols
{
    return 3;
}

@end
