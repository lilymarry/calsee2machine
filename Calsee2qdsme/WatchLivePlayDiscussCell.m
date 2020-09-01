//
//  WatchLivePlayDiscussCell.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "WatchLivePlayDiscussCell.h"

@implementation WatchLivePlayDiscussCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        UILabel *content = [UILabel new];
        content.textColor = [UIColor whiteColor];
        content.numberOfLines = 0;
        content.backgroundColor=[UIColor clearColor];
        content.font = [UIFont systemFontOfSize:12];
        self.content = content;
        [self.contentView addSubview:content];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
