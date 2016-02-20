//
//  TitleRowCell.m
//  RenewalReminder
//
//  Created by MonuRathor on 12/03/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "TitleRowCell.h"

@implementation TitleRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
