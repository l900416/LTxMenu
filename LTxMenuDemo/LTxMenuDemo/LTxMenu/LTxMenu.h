//
//  LTxMenuView.h
//  LTxMenuView
//
//  Created by liangtong on 2016/10/17.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTxMenuItem.h"

/**
 * version : 2.0
 * 变更内容：使用delegate和datasource
 *
 **/


#pragma mark LTxMenuDelegate
@protocol LTxMenuDelegate<NSObject>

@optional
-(void)didSelectRowAtIndex:(NSInteger)index;
-(void)didSelectAccessoryView:(UIView*)accessoryView
                      atIndex:(NSInteger)index;
@end

#pragma mark LTxMenuDataSource
@protocol LTxMenuDataSource<NSObject>

@required
- (NSInteger)numberOfRows;

@optional
- (NSString*)titleForRowAtIndex:(NSInteger)index;
- (NSAttributedString*)attributedTitleForRowAtIndex:(NSInteger)index;
- (UIImage*)imageForRowAtIndex:(NSInteger)index;
- (NSArray<UIView*>*)accessoryViewsAtIndex:(NSInteger)index;
@end;



@interface LTxMenuView : UIView

@property (nonatomic,copy) int(^numberOfRows)();
@property (nonatomic,copy) float(^heightForRow)(NSInteger row);
@property (nonatomic,copy) UIView*(^rowAtIndex)(NSInteger row);

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect;

- (void) dismissMenu;

@end
