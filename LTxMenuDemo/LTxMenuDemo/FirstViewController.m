//
//  FirstViewController.m
//  LTxMenuDemo
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import "FirstViewController.h"
#import "LTxMenu.h"

@interface FirstViewController ()

@property (nonatomic, strong)LTxMenuView* menuView;
@property (nonatomic, strong) NSArray* menuItems;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton* qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setImage:[UIImage imageNamed:@"ic_qq"] forState:UIControlStateNormal];
    UIButton* wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setImage:[UIImage imageNamed:@"ic_wechat"] forState:UIControlStateNormal];
    UIButton* wechatZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatZoneBtn setImage:[UIImage imageNamed:@"ic_wechat_zone"] forState:UIControlStateNormal];
    
    [qqBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [wechatZoneBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _menuItems = @[
                   @{@"image":[UIImage imageNamed:@"ic_share"],
                     @"title":@"分享到",
                     @"more":@[qqBtn,wechatBtn,wechatZoneBtn]
                     },
                   @{@"image":[UIImage imageNamed:@"ic_ favourite"],
                     @"title":@"收藏",
                     @"more":@[]
                     },
                   @{@"image":[UIImage imageNamed:@"ic_hide"],
                     @"title":@"隐藏此条动态",
                     @"more":@[]
                     },
                   @{@"image":[UIImage imageNamed:@"ic_tip-off"],
                     @"title":@"举报",
                     @"more":@[]
                     }
                   ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showMenu:(UIButton *)sender {
    
    _menuView = [[LTxMenuView alloc] init];
    __weak __typeof(self) weakSelf = self;
    _menuView.numberOfRows = ^(){
        return (int)weakSelf.menuItems.count;
    };
    _menuView.heightForRow = ^(NSInteger row){
        return 50.f;
    };
    
    _menuView.rowAtIndex = ^(NSInteger row){
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
    
}

-(void)buttonPressed:(UIButton*)sender{
    NSLog(@"more action button taped : %@",sender);
    [self.menuView dismissMenu];
}

@end
