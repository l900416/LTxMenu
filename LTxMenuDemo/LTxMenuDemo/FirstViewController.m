//
//  FirstViewController.m
//  LTxMenuDemo
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 com.liangtong. All rights reserved.
//

#import "FirstViewController.h"
#import "LTxMenuView.h"

@interface FirstViewController ()<LTxMenuViewDataSource,LTxMenuViewDelegate>

@property (nonatomic, strong)LTxMenuView* menuView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _menuView = [LTxMenuView instanceWithDataSource:self delegate:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"introduce_bg1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showMenu:(UIButton *)sender {
    
    [_menuView showMenu:self from:sender.frame];
    
}

#pragma mark LTxMenuViewDataSource
- (NSInteger)numberOfRows{
    return 4;
}
- (CGFloat)heightForRowAtIndex:(NSInteger)index{
    return 44;
}
- (NSAttributedString*)attributedTitleForRowAtIndex:(NSInteger)index{
    NSString* title = @[@"Share to",@"Favorite",@"Ignore",@"Question"][index];
    return [[NSAttributedString alloc] initWithString:title];
}
- (UIImage*)imageForRowAtIndex:(NSInteger)index{
    return @[[UIImage imageNamed:@"ic_share"],[UIImage imageNamed:@"ic_ favourite"],[UIImage imageNamed:@"ic_hide"],[UIImage imageNamed:@"ic_other"],][index];
}
- (NSArray<UIView*>*)accessoryViewsAtIndex:(NSInteger)index{
    UIImageView* qqIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_qq"]];
    qqIV.contentMode = UIViewContentModeCenter;
    UIImageView* wechatIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_wechat"]];
    wechatIV.contentMode = UIViewContentModeCenter;
    UIImageView* wechatZoneIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_qq_zone"]];
    wechatZoneIV.contentMode = UIViewContentModeCenter;
    if (index == 0) {
        return @[qqIV,wechatIV,wechatZoneIV];
    }
    return nil;
}

#pragma mark LTxMenuViewDelegate
-(void)didSelectRowAtIndex:(NSInteger)index{
    NSLog(@"didSelectRowAtIndex : %td",index);
}
-(void)didSelectAccessoryView:(UIView*)accessoryView
                      atIndex:(NSInteger)index{
    NSLog(@"didSelectRowAtIndex : %td \n accessoryView : %@",index,accessoryView);
}

@end
