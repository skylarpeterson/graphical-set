//
//  SetCarView.m
//  Graphical Set
//
//  Created by Skylar Peterson on 10/27/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SetCarView.h"

@interface SetCarView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCarView

#pragma mark - Properties

 #define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setSign:(NSInteger)sign
{
    _sign = sign;
    [self setNeedsDisplay];
}

- (void)setNumSymbols:(NSInteger)numSymbols
{
    _numSymbols = numSymbols;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setMatched:(BOOL)matched
{
    _matched = matched;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    if (self.selected) {
        [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCardDetails];
}

#define SHAPE_WIDTH_DIVIDER 2.0f;
#define SHAPE_HEIGHT_DIVIDER 4.0f;

- (CGFloat)shapeInset {
    return (self.bounds.size.height - [self shapeHeight]*self.numSymbols)/(self.numSymbols + 1);
}

- (CGFloat)shapeWidth { return self.bounds.size.width / SHAPE_WIDTH_DIVIDER; }
- (CGFloat)shapeHeight { return self.bounds.size.height / SHAPE_HEIGHT_DIVIDER; }

- (void)drawCardDetails
{
    for (int i = 1; i <= self.numSymbols; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGFloat y = self.bounds.origin.y + i * [self shapeInset] + (i - 1) * [self shapeHeight];
        CGRect ovalRect = CGRectMake(self.bounds.origin.x + [self shapeWidth]/2.0f, y, [self shapeWidth], [self shapeHeight]);
        UIBezierPath *path = [self shapePathForRect:ovalRect];
        [self.color setStroke];
        if (self.shading == 1) {
            [self.color setFill];
            [path fill];
        } else if (self.shading == 2) {
            [self drawStriping:path];
        }
        [path stroke];
        CGContextRestoreGState(context);
    }
}

- (UIBezierPath *)shapePathForRect:(CGRect)rect
{
    if (self.sign == 1) {
        UIBezierPath *squigglePath = [[UIBezierPath alloc] init];
        CGPoint origin = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height/2.0f);
        CGPoint control1 = CGPointMake(rect.origin.x + rect.size.width/3.0, rect.origin.y);
        CGPoint control2 = CGPointMake(rect.origin.x + 3*rect.size.width/4.0, rect.origin.y + rect.size.height/2.0);
        [squigglePath moveToPoint:origin];
        [squigglePath addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0f)
                        controlPoint1:control1
                        controlPoint2:control2];
        CGPoint control3 = CGPointMake(rect.origin.x + 3*rect.size.width/4.0, rect.origin.y + rect.size.height);
        CGPoint control4 = CGPointMake(rect.origin.x + rect.size.width/3.0, rect.origin.y + rect.size.height/2.0);
        [squigglePath addCurveToPoint:origin
                        controlPoint1:control3
                        controlPoint2:control4];
        return squigglePath;
    } else if (self.sign == 2) {
        UIBezierPath *diamondPath = [[UIBezierPath alloc] init];
        [diamondPath moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height/2.0f)];
        [diamondPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0f, rect.origin.y)];
        [diamondPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0f)];
        [diamondPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0f, rect.origin.y + rect.size.height)];
        [diamondPath closePath];
        return diamondPath;
    } else if (self.sign == 3) {
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];
        return oval;
    }
    return nil;
}

- (void)drawStriping:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    CGRect pathBounds = path.bounds;
    for (CGFloat x = pathBounds.origin.x; x < pathBounds.origin.x + pathBounds.size.width; x += 2.0) {
        UIBezierPath *linePath = [[UIBezierPath alloc] init];
        [linePath moveToPoint:CGPointMake(x, pathBounds.origin.y)];
        [linePath addLineToPoint:CGPointMake(x, pathBounds.origin.y + pathBounds.size.height)];
        [linePath closePath];
        [self.color setStroke];
        [linePath stroke];
    }
    CGContextRestoreGState(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
