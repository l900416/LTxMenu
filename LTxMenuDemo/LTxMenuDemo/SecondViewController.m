//
//  SecondViewController.m
//  LTxMenuDemo
//
//  Created by liangtong on 2016/10/18.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import "SecondViewController.h"
#import "LTxMenuTestTableViewCell.h"
#import "LTxMenu.h"

#define LTxMenuTestTableViewCellIdentifier  @"LTxMenuTestTableViewCellIdentifier"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)LTxMenuView* menuView;
@property (nonatomic, strong) NSArray* menuItems;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up tableview
    _dataSource = [@[] mutableCopy];
    for (NSInteger i = 1; i < 20; ++i) {
        [_dataSource addObject:[NSNumber numberWithInteger:i]];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxMenuTestTableViewCell" bundle:nil] forCellReuseIdentifier:LTxMenuTestTableViewCellIdentifier];
    self.tableView.estimatedRowHeight = 240.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //set up more action btn
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxMenuTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxMenuTestTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxMenuTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxMenuTestTableViewCellIdentifier];
    }
    cell.dateL.text = [NSString stringWithFormat:@"NO.%@", [_dataSource objectAtIndex:indexPath.row]];
    __weak __typeof(self)weakSelf = self;
    cell.actionBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGRect rowRect = [strongSelf.tableView rectForRowAtIndexPath:indexPath];
        CGFloat offsetY = rowRect.origin.y + 20 - self.tableView.contentOffset.y;
        CGRect fromRect = CGRectMake(rowRect.size.width  - 70, offsetY, 70, 31);
        [strongSelf showMoreChoiceOnRect:fromRect withIndexPath:indexPath];
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



#pragma mark - Action
- (void)showMoreChoiceOnRect:(CGRect)fromRect
              withIndexPath:(NSIndexPath*)indexPath{
    
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
        return [LTxMenuItem menuItemWithImage:[menuItem objectForKey:@"image"] title:[menuItem objectForKey:@"title"] rightBtnItems:[menuItem objectForKey:@"more"] tapBlock:^(NSString *identifier) {
            NSLog(@"tap at %@",identifier);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.menuView dismissMenu];
            if ([identifier isEqualToString:@"隐藏此条动态"]) {
                [strongSelf.dataSource removeObjectAtIndex:indexPath.row];
//                [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                NSIndexSet* sections = [NSIndexSet indexSetWithIndex:0];
                [strongSelf.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        }];
    };
    [_menuView showMenuInView:self.view
                     fromRect:fromRect];
    
}


-(void)buttonPressed:(UIButton*)sender{
    NSLog(@"more action button taped : %@",sender);
    [self.menuView dismissMenu];
}
@end
