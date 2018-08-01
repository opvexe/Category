//
//  UIView+Category.m
//  Mine
//
//  Created by Facebook on 2018/7/31.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    CGFloat tempCornerRadius = self.layer.cornerRadius;
    
    tempCornerRadius =cornerRadius;
    
    self.layer.cornerRadius = tempCornerRadius;
    
    
}
-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CGFloat pixelAdjustOffset = 0;
    if ((int)(borderWidth * [UIScreen mainScreen].scale + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(-pixelAdjustOffset, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

-(void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth andViewWidth:(CGFloat)viewWidth{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    CGFloat pixelAdjustOffset = 0;
    if ((int)(borderWidth * [UIScreen mainScreen].scale + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    border.frame = CGRectMake(0, -pixelAdjustOffset, viewWidth, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    border.name=@"border";
    [self.layer addSublayer:border];
}
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andViewWidth:(CGFloat)viewWidth{
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, viewWidth, borderWidth);
    border.name=@"border";
    [self.layer addSublayer:border];
}
- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
- (void)UILayoutCornerRadiusType:(UILayoutCornerRadiusType)sideType withCornerRadius:(CGFloat)cornerRadius
{
    
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    
    UIBezierPath *maskPath;
    
    switch (sideType) {
        case UILayoutCornerRadiusTop:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        case UILayoutCornerRadiusLeft:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:cornerSize];
        }
            break;
        case UILayoutCornerRadiusBottom:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        case UILayoutCornerRadiusRight:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        default:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:cornerSize];
        }
            break;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}

- (UIViewController *)getCurrentController{
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    [self addGestureRecognizer:tapGR];
}

- (void)addLongGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:sel];
    [self addGestureRecognizer:longGR];
}

- (void)addPanGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:target action:sel];
    [self addGestureRecognizer:panGR];
}

- (void)addLeftSwipeGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:sel];
    swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGR];
}

- (void)addRightSwipeGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:sel];
    swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGR];
}

- (void)addUpSwipeGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:sel];
    swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGR];
}

- (void)addDownSwipeGestureRecognizerWithTarget:(id)target action:(SEL)sel{
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:sel];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGR];
}

- (void)removeAllGestureRecognizer{
    for (UITapGestureRecognizer *tap in self.gestureRecognizers) {
        [self removeGestureRecognizer:tap];
    }
}
@end
