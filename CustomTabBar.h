//
//  CustomTabBar.h
//  Photo of the Day
//
//  Created by Wesley Hovanec on 11/21/15.
//  Copyright (c) 2015 Wesley Hovanec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol CustomTabBarDelegate <NSObject>

@optional
-(void)itemPressedAtIndex:(NSUInteger)index;

@end

@interface CustomTabBar : UIView

@property (nonatomic, weak)IBOutlet id<CustomTabBarDelegate> delegate;

@property (nonatomic)NSUInteger selectedTabBarItemIndex;
@property (nonatomic)NSUInteger ownersSelectedTabBarItemIndex;
@property (nonatomic, strong)NSArray *tabBarItems;

@property (nonatomic, strong)UIButton *picButton;
@property (nonatomic, strong)UIButton *infoButton;
@property (nonatomic, strong)UIButton *webButton;

@property (nonatomic, strong)UIImageView *pictureFrameBackgroundView;
@property (nonatomic, strong)UIImageView *pictureFrameView;

@end
