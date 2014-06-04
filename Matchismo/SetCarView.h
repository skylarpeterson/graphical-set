//
//  SetCarView.h
//  Graphical Set
//
//  Created by Skylar Peterson on 10/27/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCarView : UIView

@property (nonatomic) NSInteger sign;
@property (nonatomic) NSInteger numSymbols;
@property (nonatomic) UIColor *color;
@property (nonatomic) NSInteger shading;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL matched;

@end
