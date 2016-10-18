//
//  LTxMenuView.h
//  LTxMenuView
//
//  Created by liangtong on 2016/10/17.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTxMenuItem.h"

@interface LTxMenuView : UIView

@property (nonatomic,copy) int(^numberOfRows)();
@property (nonatomic,copy) float(^heightForRow)(NSInteger row);
@property (nonatomic,copy) UIView*(^rowAtIndex)(NSInteger row);

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect;

- (void) dismissMenu;

@end
