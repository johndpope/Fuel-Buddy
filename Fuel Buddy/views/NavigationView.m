//
//  NavigationView.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define DARK_COLOR UIColorFromRGB(0x163642)


#import "NavigationView.h"



@interface NavigationView ()
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (weak, nonatomic) IBOutlet UIView *searchFieldView;

@end

@implementation NavigationView

#pragma mark - Main ovveriden methods

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setGradient];
    [self setupPlaceHolder];
    [self setShadowToSearchFieldView];
}

- (void)layoutSubviews {
    self.gradient.frame = self.bounds;
}

#pragma mark - Customize

- (void)setGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.locations = @[@(0.f),@(0.2f),@(0.8f), @(1.f)];
    
    CGColorRef colorStart = [DARK_COLOR CGColor];
    CGColorRef colorBetween = [[DARK_COLOR colorWithAlphaComponent:0.9] CGColor];
    CGColorRef colorBetweenSecond = [[DARK_COLOR colorWithAlphaComponent:0.6] CGColor];
    CGColorRef colorEnd = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
    
    gradient.colors = @[(__bridge id)colorStart,(__bridge id)colorBetween, (__bridge id)colorBetweenSecond, (__bridge id)colorEnd];
    [self.layer insertSublayer:gradient atIndex:0];
    self.gradient = gradient;
}

- (void)setShadowToSearchFieldView {
    self.searchFieldView.layer.cornerRadius = 5.f;
    self.searchFieldView.layer.masksToBounds = NO;

    self.searchFieldView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.6].CGColor;
    self.searchFieldView.layer.borderWidth = 0.5f;
}

- (void)setupPlaceHolder {
    UIColor *color = [UIColor grayColor];
    self.searchField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Поиск Заправки"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont italicSystemFontOfSize:17.f]
                                                 }
     ];
}

@end
