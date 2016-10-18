//
//  EMoocCourseSectionNoteTableViewCell.m
//  EMooc
//
//  Created by liangtong on 16/8/23.
//  Copyright © 2016年 COM.SIPPR.CN. All rights reserved.
//

#import "LTxMenuTestTableViewCell.h"

@interface LTxMenuTestTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic, strong) NSString* sectionId;
@end
@implementation LTxMenuTestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

-(void)setup{
    [self.actionBtn addTarget:self action:@selector(actionBtnPress) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setActionBlock:(void (^)())actionBlock{
    _actionBlock = actionBlock;
}

-(void)actionBtnPress{
    if(_actionBlock){
        _actionBlock();
    }
}
@end
