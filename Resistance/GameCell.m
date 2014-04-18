//
//  GameCell.m
//  Resistance
//
//  Created by Varun Rau on 1/1/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import "GameCell.h"

@implementation GameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
