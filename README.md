# LTxMenu
类似支付宝、微信朋友圈、QQ空间等社交应用中的点击列表下拉按钮，展示更多功能

![](https://github.com/l900416/LTxMenu/blob/master/screenshots/1.gif)<br>

##开始使用
### 将LTxMenu文件夹中代码拖拽到工程
### pod依赖


###使用说明
```Objective-C
@property (nonatomic, strong)LTxMenuView* menuView;
```
####懒得写协议😄，所以使用block的形式：
```Objective-C
    _menuView = [[LTxMenuView alloc] init];//初始化
    __weak __typeof(self) weakSelf = self;
    _menuView.numberOfRows = ^(){//行数
        return (int)weakSelf.menuItems.count;
    };
    _menuView.heightForRow = ^(NSInteger row){//行高度
        return 50.f;
    };
    
    _menuView.rowAtIndex = ^(NSInteger row){//每行显示的内容
        NSDictionary* menuItem = [weakSelf.menuItems objectAtIndex:row];
        return [LTxMenuItem menuItemWithImage:[menuItem objectForKey:@"image"]
                                        title:[menuItem objectForKey:@"title"]
                                rightBtnItems:[menuItem objectForKey:@"more"]
                                     tapBlock:^(NSString *identifier) {
                                         NSLog(@"tap at %@",identifier);
                                         __strong __typeof(weakSelf)strongSelf = weakSelf;
                                         [strongSelf.menuView dismissMenu];
                                     }];
    };
    [_menuView showMenuInView:self.view
                     fromRect:sender.frame];
```

## iOS 版本要求
7.0

## Licence
MIT

## 其他
email：l900416@163.com
