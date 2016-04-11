//
//  CustomTabBar.m
//  Photo of the Day
//
//  Created by Wesley Hovanec on 11/21/15.
//  Copyright (c) 2015 Wesley Hovanec. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()

@property (nonatomic, getter=isAnimating)BOOL animating;
@property (nonatomic)float distanceBetweenItems;

@end

@implementation CustomTabBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedTabBarItemIndex = 0;
        _animating = NO;
        [self setupTabBar];
    }
    return self;
}

-(void)setupTabBar {
    [self setupBackground];
    [self setupButtons];
    [self setupPictureFrame];
    self.distanceBetweenItems = self.bounds.size.width / self.tabBarItems.count;
}

-(void)setupBackground {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    UIView *bgGradient = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, (self.bounds.size.height / 2) + 4)];
    bgGradient.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    bgGradient.layer.zPosition = -100;
    [self addSubview:bgGradient];
}

-(void)setupButtons {
    double buttonWidth = self.bounds.size.width/3.0;
    self.picButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonWidth, self.bounds.size.height)];
    self.infoButton = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width / 2) - (buttonWidth / 2), 0.0, buttonWidth, self.bounds.size.height)];
    self.webButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - buttonWidth, 0.0, buttonWidth, self.bounds.size.height)];
    
    [self.picButton setTitle:@"Pic" forState:UIControlStateNormal];
    [self.infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [self.webButton setTitle:@"Web" forState:UIControlStateNormal];
    
    self.tabBarItems = @[self.picButton, self.infoButton, self.webButton];
    
    for (UIButton *item in self.tabBarItems) {
        item.titleLabel.font = [UIFont fontWithName:@"Pacifico" size:20.0];
//        [item setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton *item in self.tabBarItems) {
        [self addSubview:item];
    }
}

-(void)setupPictureFrame {
    self.pictureFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, (self.bounds.size.height - 6) * 1.2, self.bounds.size.height - 6)];
    self.pictureFrameBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, (self.bounds.size.height - 12) * 1.2, self.bounds.size.height - 12)];
    
    self.pictureFrameView.contentMode = UIViewContentModeScaleToFill;
    self.pictureFrameView.image = [UIImage imageNamed:@"frame"];
    
    self.pictureFrameBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureFrameBackgroundView.image = [UIImage imageNamed:@"canvas"];
    
    self.pictureFrameView.layer.zPosition = 50;
    self.pictureFrameBackgroundView.layer.zPosition = -50;
    
    self.pictureFrameView.center = [[self.tabBarItems objectAtIndex:self.selectedTabBarItemIndex] center];
    self.pictureFrameBackgroundView.center = self.pictureFrameView.center;
    
    self.pictureFrameView.clipsToBounds = YES;
    self.pictureFrameBackgroundView.clipsToBounds = YES;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.pictureFrameBackgroundView.bounds];
    self.pictureFrameBackgroundView.layer.masksToBounds = NO;
    self.pictureFrameBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.pictureFrameBackgroundView.layer.shadowOpacity = 1.0;
    self.pictureFrameBackgroundView.layer.shadowOffset = CGSizeMake(-4.0, 2.0);
    self.pictureFrameBackgroundView.layer.shadowPath = shadowPath.CGPath;
    
    [self addSubview:self.pictureFrameView];
    [self addSubview:self.pictureFrameBackgroundView];
}

-(void)buttonDidPress:(id)sender {
    _selectedTabBarItemIndex = [self.tabBarItems indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(itemPressedAtIndex:)]) {
        [self.delegate itemPressedAtIndex:self.selectedTabBarItemIndex];
    }
    
    [self animatePictureFrameToItemAtIndex:self.selectedTabBarItemIndex];
}

-(void)animatePictureFrameToItemAtIndex:(NSUInteger)index {
    UIButton *selectedItem = self.tabBarItems[index];
    
    float currentLocation = self.pictureFrameView.layer.position.x;
    
    float toLocation = selectedItem.layer.position.x;
    
    float distance = fabsf(toLocation - currentLocation);
    
    float timingMultiplier = distance / self.distanceBetweenItems;
    
    double rotate = currentLocation > toLocation ? M_PI * -0.3 : M_PI * 0.3;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -100.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, rotate, 0.0f, 1.0f, 0.3f);
    CATransform3D undoTransform = CATransform3DIdentity;
    undoTransform.m34 = 1.0 / -100.0;
    undoTransform = CATransform3DRotate(undoTransform, 0.0, 0.0f, 0.0f, 0.0f);
    
    self.animating = YES;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pictureFrameView.bounds = CGRectMake(0.0, 0.0, self.pictureFrameView.bounds.size.width - 5, self.pictureFrameView.bounds.size.height - 5);
        self.pictureFrameBackgroundView.bounds = CGRectMake(0.0, 0.0, self.pictureFrameBackgroundView.bounds.size.width - 5, self.pictureFrameBackgroundView.bounds.size.height - 5);
        self.pictureFrameView.layer.transform = rotationAndPerspectiveTransform;
        self.pictureFrameBackgroundView.layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 * timingMultiplier delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.pictureFrameView.center = CGPointMake(toLocation, self.pictureFrameView.layer.position.y);
            self.pictureFrameBackgroundView.center = CGPointMake(toLocation, self.pictureFrameBackgroundView.layer.position.y);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.pictureFrameView.layer.transform = undoTransform;
                self.pictureFrameBackgroundView.layer.transform = undoTransform;
                self.pictureFrameView.bounds = CGRectMake(0.0, 0.0, self.pictureFrameView.bounds.size.width + 5, self.pictureFrameView.bounds.size.height + 5);
                self.pictureFrameBackgroundView.bounds = CGRectMake(0.0, 0.0, self.pictureFrameBackgroundView.bounds.size.width + 5, self.pictureFrameBackgroundView.bounds.size.height + 5);
            } completion:^(BOOL finished) {
                self.animating = NO;
//                if (self.selectedTabBarItemIndex != self.ownersSelectedTabBarItemIndex) {
//                    [self animatePictureFrameToItemAtIndex:self.ownersSelectedTabBarItemIndex];
//                }
            }];
        }];
    }];
    
    
}

@end
