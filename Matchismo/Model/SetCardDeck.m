//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/15/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (int sign = 1; sign <= [SetCard numSigns]; sign++) {
            for (NSInteger color = 1; color <= [SetCard numColors]; color++) {
                for (NSInteger shading = 1; shading <= [SetCard numShading]; shading++) {
                    for (NSUInteger rank = 1; rank <= [SetCard maxNumSymbols]; rank++) {
                        SetCard *card = [[SetCard alloc] initWithSign:sign
                                                             andColor:color
                                                           andShading:shading
                                                             andValue:rank];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
