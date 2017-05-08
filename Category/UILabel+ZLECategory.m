//
//  UILabel+ZLECategory.m
//  UILabel类别
//
//  Created by layne on 17/4/19.
//  Copyright © 2017年 layne. All rights reserved.
//

#import "UILabel+ZLECategory.h"

@implementation UILabel (ZLECategory)

/* 两端对齐 */
- (void)justifiedAlignment{
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGFloat margin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedStr addAttribute:NSKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributedStr;
    
}

@end
