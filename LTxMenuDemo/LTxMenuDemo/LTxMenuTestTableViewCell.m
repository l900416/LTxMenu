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

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
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

-(void)setCellModel:(NSDictionary *)cellModel{
    _cellModel = cellModel;
    NSString* avatar = [cellModel objectForKey:@"avatar"];
    NSString* name = [cellModel objectForKey:@"name"];
    NSString* date = [cellModel objectForKey:@"date"];
    NSString* content = [cellModel objectForKey:@"content"];
    UIColor* color = [cellModel objectForKey:@"color"];
    self.avatarIV.image = [UIImage imageNamed:avatar];
    self.nameL.text = name;
    self.dateL.text = date;
    self.contentL.text = content;
    if (color) {
        self.contentL.textColor = color;
    }
}
@end
