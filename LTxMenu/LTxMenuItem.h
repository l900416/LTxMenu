//
//  LTxMenuItem.h
//  LTxMenuView
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTxMenuItem : UIView

@property (nonatomic, strong) NSString* identifier;

@property (nonatomic, strong) UIImageView* leftIV;
@property (nonatomic, strong) UILabel* titleL;
@property (nonatomic, strong) NSArray* rightBtnItems;

+(instancetype)menuItemWithImage:(UIImage*)image
                           title:(NSString*)title
                      rightBtnItems:(NSArray*)rightBtnItems
                        tapBlock:(void(^)(NSString* identifier))tapBlock;

@end
