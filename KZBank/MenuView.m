//
//  MenuView.m
//  KZBank
//
//  Created by Dymov, Yuri on 5/13/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "MenuView.h"
#import "FinanceViewController.h"
#import "CardViewController.h"
#import "RevenueViewController.h"
#import "ViewController.h"
#import "Cache.h"

@interface MenuView()

@property (nonatomic, weak) UINavigationController *_navController;
@property (nonatomic, strong) NSMutableArray *_buttons;

@end

@implementation MenuView
@synthesize activeIndex;
@synthesize _navController;
@synthesize _buttons;

- (id)initWithFrame:(CGRect)frame andNavigationController:(UINavigationController*)navController{
    self = [super initWithFrame:frame];
    if (self) {
        self._buttons = [NSMutableArray new];
        activeIndex = -1;
        self._navController = navController;
        NSArray *buttons = @[@"index", @"menu_finance", @"revenue", @"card", @"flow"];
        for (NSInteger i = 0; i < buttons.count; ++i) {
            UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [indexButton addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
            indexButton.frame = CGRectMake(i * 110, 5, 91, 68);
            [indexButton setImage:[UIImage imageNamed:[buttons objectAtIndex:i]] forState:UIControlStateNormal];
            indexButton.tag = i;
            [self addSubview:indexButton];
            [_buttons addObject:indexButton];
        }        
    }
    return self;
}

- (void)pressed:(UIButton*)sender {
    if (sender.tag != activeIndex) {
        ADTransitioningViewController *vc = [Cache vcAtIndex:sender.tag];
        ADTransitionOrientation transition = ADTransitionLeftToRight;
        if (sender.tag > activeIndex)
            transition = ADTransitionRightToLeft;
        vc.transition = [[ADCubeTransition alloc] initWithDuration:0.8f orientation:transition sourceRect:[UIScreen mainScreen].bounds];

        [self._navController setViewControllers:@[[Cache vcAtIndex:sender.tag]] animated:YES];
    }
}


- (void)setActiveIndex:(NSInteger)anActiveIndex {
    activeIndex = anActiveIndex;
    UIButton *btn = [_buttons objectAtIndex:anActiveIndex];
    btn.layer.borderColor = [UIColor colorWithRed:218.0/0x100 green:167.0/0x100 blue:3.0/0x100 alpha:1.0].CGColor;
    btn.layer.borderWidth = 5;
}


@end
