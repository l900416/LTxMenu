//
//  SecondViewController.m
//  LTxMenuDemo
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import "SecondViewController.h"
#import "LTxMenuTestTableViewCell.h"
#import "LTxMenuView.h"

#define LTxMenuTestTableViewCellIdentifier  @"LTxMenuTestTableViewCellIdentifier"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,LTxMenuViewDataSource,LTxMenuViewDelegate>

@property (nonatomic,strong) NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LTxMenuView* menuView;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"LTxMenuView";
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"introduce_bg1"]];
    
    //set up tableview
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxMenuTestTableViewCell" bundle:nil] forCellReuseIdentifier:LTxMenuTestTableViewCellIdentifier];
    self.tableView.estimatedRowHeight = 240.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //set up more action btn
    _menuView = [LTxMenuView instanceWithDataSource:self delegate:self];
    _menuView.menuArrowSize = 12.f;
    _menuView.defaultPadding = 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxMenuTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxMenuTestTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxMenuTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxMenuTestTableViewCellIdentifier];
    }
    cell.cellModel = [self.dataSource objectAtIndex:indexPath.row];
    __weak __typeof(self)weakSelf = self;
    cell.actionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedIndexPath = indexPath;
        CGRect rowRect = [strongSelf.tableView rectForRowAtIndexPath:indexPath];
        CGFloat offsetY = rowRect.origin.y + 20 - self.tableView.contentOffset.y;
        CGRect fromRect = CGRectMake(rowRect.size.width  - 70, offsetY, 70, 31);
        [strongSelf.menuView showMenu:strongSelf.navigationController from:fromRect];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LTxMenuViewDataSource
- (NSInteger)numberOfRows{
    return 4;
}
- (CGFloat)heightForRowAtIndex:(NSInteger)index{
    return 56;
}
- (NSAttributedString*)attributedTitleForRowAtIndex:(NSInteger)index{
    NSString* title = @[@"Share to",@"Favorite",@"Ignore",@"Other"][index];
    UIColor* textColor;
    UIFont* textFont = [UIFont systemFontOfSize:17.f];
    if (index == 0) {
        textColor = [UIColor colorWithRed:59/255.0 green:145/255.0 blue:233/255.0 alpha:1];
    }else if (index == 1) {
        textColor = [UIColor redColor];
        textFont = [UIFont boldSystemFontOfSize:19.f];
    }else if (index == 2) {
        textColor = [UIColor grayColor];
    }else{
        textColor = [UIColor brownColor];
    }
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:textColor,
                                                                         NSFontAttributeName:textFont}];
}
- (UIImage*)imageForRowAtIndex:(NSInteger)index{
    return @[[UIImage imageNamed:@"ic_share"],
             [UIImage imageNamed:@"ic_ favourite"],
             [UIImage imageNamed:@"ic_hide"],
             [UIImage imageNamed:@"ic_other"],][index];
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
    }else if (index == 3){
        return @[wechatZoneIV];
    }
    return nil;
}

#pragma mark LTxMenuViewDelegate
-(void)didSelectRowAtIndex:(NSInteger)index{
    NSLog(@"didSelectRowAtIndex : %td",index);
    if (index == 2) {
        [self.dataSource removeObjectAtIndex:self.selectedIndexPath.row];
        NSIndexSet* sections = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)didSelectAccessoryView:(UIView*)accessoryView
                      atIndex:(NSInteger)index{
    NSLog(@"didSelectRowAtIndex : %td \n accessoryView : %@",index,accessoryView);
}

#pragma mark Test
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [@[
                         @{
                             @"avatar":@"ic_user_gray_header",
                             @"name":@"Jack",
                             @"date":@"Just now",
                             @"content":@"   Often appear in dreams, wake up you should see him."
                             },
                         @{
                             @"avatar":@"avatar1",
                             @"name":@"纳兰容若",
                             @"date":@"5 minute ago",
                             @"content":@"   人生若只如初见， 何事秋风悲画扇。\n   等闲变却故人心， 却道故人心易变。\n   骊山语罢清宵半， 泪雨零铃终不怨。\n   何如薄幸锦衣郎， 比翼连枝当日愿。",
                             @"color":[UIColor brownColor],
                             },
                         @{
                             @"avatar":@"avatar2",
                             @"name":@"梁通",
                             @"date":@"2 days ago",
                             @"content":@"   Like Facebook News Feed , Alipay Life , QZone and other social applications. I didn’t find any on GitHub , so I wrote  a similar UI controls myself using Objective-C. Reference : https://github.com/kolyvan/kxmenu"
                             },
                         @{
                             @"avatar":@"avatar3",
                             @"name":@"Joker.Jemmy",
                             @"date":@"1 week ago",
                             @"content":@"How To Use :\n   Drag the file to the project. \n   pod LTxMenu"
                             },
                         @{
                             @"avatar":@"avatar4",
                             @"name":@"whosyourdaddy",
                             @"date":@"2017-02-03",
                             @"content":@"    You smiled and talked to me of nothing and I felt that for this I had been waiting long. "
                             },
                         @{
                             @"avatar":@"avatar2",
                             @"name":@"Tom Cat",
                             @"date":@"2017-02-02",
                             @"content":@" Shadow, with her veil drawn, follows Light in secret meekness,with her silent steps of love."
                             },
                         @{
                             @"avatar":@"avatar3",
                             @"name":@"Micheal",
                             @"date":@"2017-01-03",
                             @"content":@"    Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
                             },
                         @{
                             @"avatar":@"avatar4",
                             @"name":@"Peter.White",
                             @"date":@"2017-01-01",
                             @"content":@" coming days would be long. After all do not grow, grey-haired."
                             }
                         
                         
                         ] mutableCopy];
    }
    return _dataSource;
}
@end
