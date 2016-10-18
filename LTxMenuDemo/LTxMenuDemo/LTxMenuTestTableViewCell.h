//
//  EMoocCourseSectionNoteTableViewCell.h
//  EMooc
//
//  Created by liangtong on 16/8/23.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTxMenuTestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateL;

@property (nonatomic,copy) void(^actionBlock)();

@end
