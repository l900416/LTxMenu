//
//  EMoocCourseSectionNoteTableViewCell.h
//  EMooc
//
//  Created by liangtong on 16/8/23.
//  Copyright © 2016年 com.liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTxMenuTestTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary* cellModel;


@property (nonatomic,copy) void(^actionBlock)();

@end
