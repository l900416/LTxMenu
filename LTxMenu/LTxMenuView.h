//
//  LTxMenuView.h
//  LTxMenuDemo
//
//  Created by 梁通 on 2017/5/19.
//  Copyright © 2017年 COM.SIPPR.CN. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark LTxMenuViewDelegate
@protocol LTxMenuViewDelegate<NSObject>

@optional
/**
 * called when a specified index was selected.
 **/
-(void)didSelectRowAtIndex:(NSInteger)index;

/**
 * called when a specified accessoryView was selected.
 **/
-(void)didSelectAccessoryView:(UIView*)accessoryView
                      atIndex:(NSInteger)index;
@end

#pragma mark LTxMenuViewDataSource
@protocol LTxMenuViewDataSource<NSObject>

@required
/**
 * Returns the number of rows
 **/
- (NSInteger)numberOfRows;

@optional
/**
 * Returns the height of specified index. default value is 50.
 **/
- (CGFloat)heightForRowAtIndex:(NSInteger)index;

/**
 * Returns the attributedTitle of specified index.
 **/
- (NSAttributedString*)attributedTitleForRowAtIndex:(NSInteger)index;

/**
 * Returns the image of specified index.
 **/
- (UIImage*)imageForRowAtIndex:(NSInteger)index;

/**
 * Returns the accessoryViews placed at the end of specified index.
 **/
- (NSArray<UIView*>*)accessoryViewsAtIndex:(NSInteger)index;
@end;

#pragma mark LTxMenuView

@interface LTxMenuView : UIView

/**
 * the menuview arrow size. default value is 6.f
 **/
@property (nonatomic, assign) CGFloat menuArrowSize;

/**
 * the padding between subviews. default value is 8;
 **/
@property (nonatomic, assign) CGFloat defaultPadding;

/**
 * dataSource and delegate
 **/
@property (nonatomic, weak) id <LTxMenuViewDataSource> dataSource;
@property (nonatomic, weak) id <LTxMenuViewDelegate> delegate;

/**
 * class instance method with dataSource and delegate. you can also create with [[LTxMenuView alloc] init] then set the dataSource and the delegate.
 **/
+ (instancetype)instanceWithDataSource:(id <LTxMenuViewDataSource>)dataSource delegate:(id <LTxMenuViewDelegate>)delegate;

/**
 * show menuView in viewController from a special position.
 * @param viewController the menuview 's container
 * @param position the menuview 's arrow direction
 **/
- (void)showMenu:(UIViewController*)viewController from:(CGRect)position;
/**
 * hide the menuview. usually you did not need to call this method
 **/
- (void)dismissMenu;

@end
