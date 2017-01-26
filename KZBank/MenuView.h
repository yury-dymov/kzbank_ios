//
//  MenuView.h
//  KZBank
//
//  Created by Dymov, Yuri on 5/13/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

- (id)initWithFrame:(CGRect)frame andNavigationController:(UINavigationController*)navController;

@property (nonatomic, assign) NSInteger activeIndex;

@end
