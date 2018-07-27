# LTxMenu

## [DEPRECATED] New Repo： https://github.com/liangtongdev/LTxPopup

LTxPopupMenu 

---

Similar to Facebook News Feed , Alipay Life ,   QZone and other social applications . A popover menu view

![](https://github.com/l900416/LTxMenu/blob/master/screenshots/1.png)

### Why

In Facebook News Feed , Alipay Life ,   QZone and other social applications , they all contain a function drop-down button which would show a list of more functions when taped . 
I didn’t find any on GitHub , so I wrote  a similar UI controls myself using Objective-C. Reference : https://github.com/kolyvan/kxmenu


### Installation with CocoaPods


LTxMenu is available in CocoaPods, specify it in your *Podfile*:

    pod 'LTxMenu'


### Deployment
    8.0

### Usage

#### Create 

```Objective-C
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

```   

#### DataSource And Delegate 

```Objective-C

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
```

### Licence
   LTxMenu is available under the **MIT** license. See the LICENSE file for more info.

