//
//  LTxMenuItem.m
//  LTxMenuView
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import "LTxMenuItem.h"

@interface LTxMenuItem()

@property (nonatomic, copy) void(^tapBlock)(NSString* identifier);

@property (nonatomic, strong) UIView* rightActionBtnsView;

@end

@implementation LTxMenuItem

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
        _titleL.textColor = [UIColor darkGrayColor];
        [self addSubview:_titleL];
        
        _rightActionBtnsView = [[UIView alloc] init];
        _rightActionBtnsView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_rightActionBtnsView];
    }
    
    return self;
}

static float defaultPadding = 5.f;
static float rightActionBtnWidth = 56.f;

+(instancetype)menuItemWithImage:(UIImage*)image
                           title:(NSString*)title
                      rightBtnItems:(NSArray*)rightBtnItems
                        tapBlock:(void(^)(NSString* identifier))tapBlock{
    LTxMenuItem* retInstance = [[LTxMenuItem alloc] init];
    retInstance.tapBlock = tapBlock;
    retInstance.rightBtnItems = rightBtnItems;
    
    retInstance.leftIV.image = image;
    [retInstance updateConstraintsWithImageVisible:image!=nil];
    
    [retInstance updateRightBtnsViews];
    
    retInstance.titleL.text = title;
    retInstance.identifier = title;//default value
    [retInstance updateTitleLabelConstraints];

    return retInstance;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    if (self.tapBlock) {
        self.tapBlock(self.identifier);
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
                                                      constant:defaultPadding]];
    //约束-上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:defaultPadding]];
    //约束-下
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:-defaultPadding * 2]];
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


-(void)updateRightBtnsViews{
    CGFloat width = rightActionBtnWidth * self.rightBtnItems.count;
    
    //add sub view
    for (NSInteger i = 0; i < self.rightBtnItems.count; ++i) {
        UIButton* actionBtn = [self.rightBtnItems objectAtIndex:i];
        actionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightActionBtnsView addSubview:actionBtn];
        if (i == 0) {
            //左
            [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_rightActionBtnsView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.f
                                                              constant:0]];
        }
        
        if (i == self.rightBtnItems.count - 1){
            //右
            [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_rightActionBtnsView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.f
                                                              constant:0]];
        }
        
        
        
        //约束-上
        [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_rightActionBtnsView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0]];
        //约束-下
        [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_rightActionBtnsView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.f
                                                          constant:0]];
        
        if (i > 0) {
            UIButton* preActionBtn = [self.rightBtnItems objectAtIndex:i - 1];
            //左右间距
            [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:preActionBtn
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.f
                                                              constant:defaultPadding]];
//            等宽度
            [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:actionBtn
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:preActionBtn
                                                                             attribute:NSLayoutAttributeWidth
                                                                            multiplier:1.f
                                                                              constant:0]];
        }
    }

    
    //左
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightActionBtnsView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleL
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.f
                                                      constant:-defaultPadding]];
    
    //右
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightActionBtnsView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.f
                                                      constant:-defaultPadding]];
    //约束-上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightActionBtnsView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:defaultPadding]];
    //约束-下
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightActionBtnsView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:-defaultPadding * 2]];
    
    //约束-宽度
    [_rightActionBtnsView addConstraint:[NSLayoutConstraint constraintWithItem:_rightActionBtnsView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:width]];
    
}

-(void)updateTitleLabelConstraints{
    //左
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftIV
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleL
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.f
                                                      constant:-defaultPadding]];
    //约束-上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:defaultPadding]];
    //约束-下
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:-defaultPadding * 2]];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
