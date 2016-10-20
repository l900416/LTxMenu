# LTxMenu
Similar to Facebook News Feed , Alipay Life ,   QZone and other social applications . click a drop-down button  to display more functions

![](https://github.com/l900416/LTxMenu/blob/master/screenshots/1.gif)<br>

###Why
In Facebook News Feed , Alipay Life ,   QZone and other social applications , they all contain a function drop-down button which would show a list of more functions when taped . 
I didn’t find any on GitHub , so I wrote  a similar UI controls myself using Objective-C. Reference : https://github.com/kolyvan/kxmenu


###Get Start
> * Drag the file to the project
> * pod LTxMenu


###How To Use
```Objective-C
@property (nonatomic, strong)LTxMenuView* menuView;
```
I was too lazy to write a protocol😄，Use callback methods：
```Objective-C
    _menuView = [[LTxMenuView alloc] init];//init
    __weak __typeof(self) weakSelf = self;
    _menuView.numberOfRows = ^(){//row numbers
        return (int)weakSelf.menuItems.count;
    };
    _menuView.heightForRow = ^(NSInteger row){//height of a row
        return 50.f;
    };
    
    _menuView.rowAtIndex = ^(NSInteger row){//the content of a row
        NSDictionary* menuItem = [weakSelf.menuItems objectAtIndex:row];
        return [LTxMenuItem menuItemWithImage:[menuItem objectForKey:@"image"]
                                        title:[menuItem objectForKey:@"title"]
                                rightBtnItems:[menuItem objectForKey:@"more"]//An array contains subClass of UIView
                                     tapBlock:^(NSString *identifier) {
                                         NSLog(@"tap at %@",identifier);
                                         __strong __typeof(weakSelf)strongSelf = weakSelf;
                                         [strongSelf.menuView dismissMenu];
                                     }];
    };
    [_menuView showMenuInView:self.view
                     fromRect:sender.frame];
```

### Deployment
7.0

### Licence
MIT

### email
l900416@163.com
