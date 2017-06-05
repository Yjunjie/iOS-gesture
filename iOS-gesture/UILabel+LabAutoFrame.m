

//
//  UILabel+LabAutoFrame.m
//  LABAutoFrame
//
//  Created by doublej on 15/6/2.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "UILabel+LabAutoFrame.h"

@implementation UILabel (LabAutoFrame)

- (void)setWidthWithString:(NSString *)enteredStr
{
    CGSize size = [enteredStr sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, size.width,self.frame.size.height)];
    
}

- (void)setHeightWithString:(NSString *)enteredStr
{
    
    
    CGSize size = [enteredStr sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, size.height)];
}
@end
