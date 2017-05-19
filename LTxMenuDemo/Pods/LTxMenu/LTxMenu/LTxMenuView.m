//
//  LTxMenuView.m
//  LTxMenuDemo
//
//  Created by 梁通 on 2017/5/19.
//  Copyright © 2017年 COM.SIPPR.CN. All rights reserved.
//

#import "LTxMenuView.h"

//弹出框箭头方向
typedef NS_ENUM(NSUInteger, LTxMenuViewArrowDirection) {
    LTxMenuViewArrowDirectionNone,               // 无箭头
    LTxMenuViewArrowDirectionUp,                 // 上箭头
    LTxMenuViewArrowDirectionDown,               // 向下箭头
};

#pragma mark LTxMenuViewOverlay

@interface LTxMenuViewOverlay : UIView
@end

@implementation LTxMenuViewOverlay

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.17];
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
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


#pragma mark LTxMenuViewItem
@interface LTxMenuViewItem : UIView
@property (nonatomic, strong) UIImageView* leftIV;
@property (nonatomic, strong) UILabel* titleL;
@property (nonatomic, strong) NSArray* accessoryViews;
@property (nonatomic, copy) void(^tapBlock)(LTxMenuViewItem* view, UIView* accessoryView);
@property (nonatomic, assign) CGFloat defaultPadding;
@end

@implementation LTxMenuViewItem
-(id)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
        
        _leftIV = [[UIImageView alloc] init];
        _leftIV.translatesAutoresizingMaskIntoConstraints = NO;
        _leftIV.contentMode = UIViewContentModeCenter;
        [self addSubview:_leftIV];
        
        _titleL = [[UILabel alloc] init];
        _titleL.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_titleL];
    }
    
    return self;
}

+(instancetype)menuItemWithImage:(UIImage*)image
                           title:(NSAttributedString*)title
                  accessoryViews:(NSArray*)accessoryViews
                  defaultPadding:(CGFloat)defaultPadding
                        tapBlock:(void(^)(LTxMenuViewItem* view, UIView* accessoryView))tapBlock{
    LTxMenuViewItem* retInstance = [[LTxMenuViewItem alloc] init];
    retInstance.defaultPadding = defaultPadding;
    retInstance.tapBlock = tapBlock;
    retInstance.accessoryViews = accessoryViews;
    
    retInstance.leftIV.image = image;
    [retInstance updateConstraintsWithImageVisible:image!=nil];
    
    retInstance.titleL.attributedText = title;
    [retInstance updateTitleLabelConstraints];
    
    [retInstance updateRightAccessoryViews];
    return retInstance;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    CGPoint locationInView = [recognizer locationInView:self];
    UIView* accessoryView;
    for (UIView* subView in self.subviews) {
        if ([subView isEqual:self.leftIV] || [subView isEqual:self.titleL] ) {
            continue;
        }
        CGRect subViewFrame = subView.frame;
        if (CGRectContainsPoint(subViewFrame, locationInView)) {
            accessoryView = subView;
            break;
        }
    }
    if (self.tapBlock) {
        self.tapBlock(self,accessoryView);
    }
}


-(void)updateConstraintsWithImageVisible:(BOOL)imageVisible{
    //约束-左
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.f
                                                      constant:self.defaultPadding]];
    //约束-上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0]];
    //约束-下
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:0]];
    if (imageVisible) {
        //约束-宽度
        [_leftIV addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_leftIV
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.f
                                                             constant:0]];
    }else{
        //约束-宽度
        [_leftIV addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:0]];
    }
}


-(void)updateRightAccessoryViews{
    
    //add sub view
    CGFloat rightPadding = self.defaultPadding;
    for (NSInteger i = 0 ; i < self.accessoryViews.count; ++i) {
        UIView* actionBtn = [self.accessoryViews objectAtIndex:i];
        actionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:actionBtn];
        
        //约束-上
        [self addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0]];
        //约束-下
        [self addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.f
                                                          constant:0]];
        //右
        [self addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.f
                                                          constant:- rightPadding]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:actionBtn
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.f
                                                          constant:0]];
        
        rightPadding += CGRectGetHeight(actionBtn.bounds) +  self.defaultPadding;
    }
}

-(void)updateTitleLabelConstraints{
    //左
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleL
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.f
                                                      constant:-self.defaultPadding]];
    //约束-上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0]];
    //约束-下
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:0]];
    
}

@end

#pragma mark LTxMenuView

@interface LTxMenuView()

@property (nonatomic , assign) LTxMenuViewArrowDirection arrowDirection;
@property (nonatomic , assign) CGFloat arrowPosition;
@property (nonatomic , strong) UIView* contentView;

@end

@implementation LTxMenuView




static LTxMenuView *_instance = nil;

+ (instancetype)instanceWithDataSource:(id <LTxMenuViewDataSource>)dataSource delegate:(id <LTxMenuViewDelegate>)delegate{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LTxMenuView alloc] init];
    });
    _instance.dataSource = dataSource;
    _instance.delegate = delegate;
    return _instance;
}

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




- (void)showMenu:(UIViewController*)viewController from:(CGRect)position{
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    UIView* controllerView = viewController.view;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.autoresizingMask = UIViewAutoresizingNone;
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.opaque = NO;
    //    UITapGestureRecognizer *gestureRecognizer;
    //    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                                                action:@selector(singleTap:)];
    //
    //    [_contentView addGestureRecognizer:gestureRecognizer];
    [self addSubview:_contentView];
    
    //将menuItems添加到_contentView中，并确定高度和宽度
    CGFloat width = CGRectGetWidth(controllerView.bounds) - 10.f;
    NSInteger totalRowNum = self.dataSource.numberOfRows;
    CGFloat height = 0.f;
    for (NSInteger iRowNum = 0; iRowNum < totalRowNum; ++iRowNum) {
        //计算高度
        CGFloat rowHeight = 50;
        if ([self.dataSource respondsToSelector:@selector(heightForRowAtIndex:)]) {
            rowHeight = [self.dataSource heightForRowAtIndex:iRowNum];
        }
        //添加SubView
        UIImage* image = nil;
        if ([self.dataSource respondsToSelector:@selector(imageForRowAtIndex:)]) {
            image = [self.dataSource imageForRowAtIndex:iRowNum];
        }
        NSAttributedString* title = nil;
        if ([self.dataSource respondsToSelector:@selector(attributedTitleForRowAtIndex:)]) {
            title = [self.dataSource attributedTitleForRowAtIndex:iRowNum];
        }
        
        NSArray* accessoryViews = nil;
        if ([self.dataSource respondsToSelector:@selector(accessoryViewsAtIndex:)]) {
            accessoryViews = [self.dataSource accessoryViewsAtIndex:iRowNum];
        }
        LTxMenuViewItem* rowView = [LTxMenuViewItem menuItemWithImage:image title:title accessoryViews:accessoryViews defaultPadding:self.defaultPadding tapBlock:^(LTxMenuViewItem* view, UIView* accessoryView){
            if (self.delegate) {
                if (accessoryView) {
                    if ([self.delegate respondsToSelector:@selector(didSelectAccessoryView:atIndex:)]) {
                        [self.delegate didSelectAccessoryView:accessoryView atIndex:iRowNum];
                    }
                }else{
                    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)]) {
                        [self.delegate didSelectRowAtIndex:iRowNum];
                    }
                }
            }
            [self dismissMenu];
        }];
        if (rowView) {
            [rowView setFrame:CGRectMake(0, height + 5, width, rowHeight)];
            [_contentView addSubview:rowView];
            height += (rowHeight + 1);
            if (iRowNum != totalRowNum - 1) {
                UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, height + 3, width - 10, 1)];
                lineV.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                [_contentView addSubview:lineV];
            }
        }
    }
    
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.size.width = width;
    contentViewFrame.size.height = height + 8;
    _contentView.frame = contentViewFrame;
    
    
    //绘制弹出框及箭头
    const CGSize contentSize = _contentView.frame.size;
    const CGFloat outerWidth = controllerView.bounds.size.width;
    const CGFloat outerHeight = controllerView.bounds.size.height;
    
    const CGFloat rectXM = position.origin.x + position.size.width * 0.5f;
    const CGFloat rectY0 = position.origin.y;
    const CGFloat rectY1 = position.origin.y + position.size.height;
    
    const CGFloat heightPlusArrow = contentSize.height + self.menuArrowSize;
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
        _contentView.frame = (CGRect){0, self.menuArrowSize, contentSize};
        
        self.frame = (CGRect) {
            point,
            contentSize.width,
            contentSize.height + self.menuArrowSize
        };
        
    }else if (heightPlusArrow < rectY0) {
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
            contentSize.height + self.menuArrowSize
        };
        
    }else {
        _arrowDirection = LTxMenuViewArrowDirectionNone;
        self.frame = (CGRect) {
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
    
    LTxMenuViewOverlay *overlay = [[LTxMenuViewOverlay alloc] initWithFrame:controllerView.bounds];
    [overlay addSubview:self];
    [controllerView addSubview:overlay];
    
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
    
    [self setNeedsDisplay];
    
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
                             
                             if ([self.superview isKindOfClass:[LTxMenuViewOverlay class]])
                                 [self.superview removeFromSuperview];
                             [self removeFromSuperview];
                         }];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    //hook to avoid the tap gesture
    UIView* tapedView = recognizer.view;
    
    NSLog(@"%@:%@",self,tapedView);
    
    //    CGPoint locationInView = [recognizer locationInView];
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

- (void) drawRect:(CGRect)rect{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

//描画尖角和边框
- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context{
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
        const CGFloat arrowX0 = arrowXM - self.menuArrowSize;
        const CGFloat arrowX1 = arrowXM + self.menuArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + self.menuArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        
        [[UIColor whiteColor] set];
        
        Y0 += self.menuArrowSize;
        
    } else if (_arrowDirection == LTxMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - self.menuArrowSize;
        const CGFloat arrowX1 = arrowXM + self.menuArrowSize;
        const CGFloat arrowY0 = Y1 - self.menuArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor whiteColor] set];
        
        Y1 -= self.menuArrowSize;
        
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

#pragma mark - Getter && Setter
-(CGFloat)menuArrowSize{
    if (_menuArrowSize <= 0) {
        _menuArrowSize = 6.f;
    }
    return _menuArrowSize;
}
-(CGFloat)defaultPadding{
    if (_defaultPadding <= 0) {
        _defaultPadding = 8.f;
    }
    return _defaultPadding;
}
@end
