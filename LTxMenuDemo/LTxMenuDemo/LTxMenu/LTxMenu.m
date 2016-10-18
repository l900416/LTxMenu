//
//  LTxMenuView.m
//  LTxMenuView
//
//  Created by liangtong on 2016/10/17.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "LTxMenu.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@interface LTxMenuOverlay : UIView
@end

@implementation LTxMenuOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.17];
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *v in self.subviews) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ( [v respondsToSelector:@selector(dismissMenu)]) {
            [v performSelector:@selector(dismissMenu) withObject:nil];
        }
#pragma clang diagnostic pop
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

typedef enum {
    
    LTxMenuViewArrowDirectionNone,
    LTxMenuViewArrowDirectionUp,
    LTxMenuViewArrowDirectionDown,
} LTxMenuViewArrowDirection;



@implementation LTxMenuView {
    
    LTxMenuViewArrowDirection    _arrowDirection;
    CGFloat                     _arrowPosition;
    UIView                      *_contentView;
}

static CGFloat lxArrowSize = 6.f;

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.opaque = YES;
        self.alpha = 0;
        
    }
    
    return self;
}


- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;

    const CGFloat heightPlusArrow = contentSize.height + lxArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;

    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = LTxMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){0, lxArrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + lxArrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = LTxMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + lxArrowSize
        };
        
    }  else {
        
        _arrowDirection = LTxMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}


- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect{
    
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    //将menuItems添加到_contentView中，并确定高度和宽度
    CGFloat width = CGRectGetWidth(view.bounds) - 10.f;
    NSInteger totalRowNum = self.numberOfRows();
    CGFloat height = 0.f;
    for (NSInteger iRowNum = 0; iRowNum < totalRowNum; ++iRowNum) {
        //计算高度
        CGFloat rowHeight = self.heightForRow(iRowNum);
        
        //添加SubView
        UIView* rowView = self.rowAtIndex(iRowNum);
        if (rowView) {
            [rowView setFrame:CGRectMake(0, height + 5, width, rowHeight)];
            [_contentView addSubview:rowView];
            height += (rowHeight + 1);
            if (iRowNum != totalRowNum - 1) {
                UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, height, width - 10, 1)];
                lineV.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                [_contentView addSubview:lineV];
            }
        }
    }
    
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.size.width = width;
    contentViewFrame.size.height = height + 8;
    _contentView.frame = contentViewFrame;
    
    
    [self setupFrameInView:view fromRect:rect];
    
    LTxMenuOverlay *overlay = [[LTxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    
    //Menu弹出动画
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationWillChange:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    
}

- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}

- (void)dismissMenu
{
    if (self.superview) {
        const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
        _contentView.hidden = YES;
        //Menu收回动画
        [UIView animateWithDuration:0.2
                         animations:^(void) {
                             
                             self.alpha = 0;
                             self.frame = toFrame;
                             
                         } completion:^(BOOL finished) {
                             
                             if ([self.superview isKindOfClass:[LTxMenuOverlay class]])
                                 [self.superview removeFromSuperview];
                             [self removeFromSuperview];
                         }];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *) mkContentView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    
    contentView.backgroundColor = [UIColor clearColor];
    
    contentView.opaque = NO;
    
    UITapGestureRecognizer *gestureRecognizer;
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(singleTap:)];
    
    [contentView addGestureRecognizer:gestureRecognizer];
    
    return contentView;
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    //hook to avoid the tap gesture
}


- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == LTxMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == LTxMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

//描画尖角和边框
- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == LTxMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - lxArrowSize;
        const CGFloat arrowX1 = arrowXM + lxArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + lxArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        
        [[UIColor whiteColor] set];
        
        Y0 += lxArrowSize;
        
    } else if (_arrowDirection == LTxMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - lxArrowSize;
        const CGFloat arrowX1 = arrowXM + lxArrowSize;
        const CGFloat arrowY0 = Y1 - lxArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor whiteColor] set];
        
        Y1 -= lxArrowSize;
        
    }
    
    [arrowPath fill];
    
    // render body
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    //修改菜单圆角
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:5.f];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        1, 1, 1, 1,
        1, 1, 1, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    start = (CGPoint){X0, Y0};
    end = (CGPoint){X0, Y1};
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
