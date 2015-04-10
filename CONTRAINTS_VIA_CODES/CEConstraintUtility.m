//
//  CEViewUtility.m
//  EmrDemo
//
//  Created by Tacktile Systems on 7/15/14.
//  Copyright (c) 2014 Cocoa. All rights reserved.
//

#import "CEConstraintUtility.h"

@implementation CEConstraintUtility

+(void)applyMatchParentConstraint:(NSInteger) leftMargin andRightMargin:(NSInteger) rightMargin forView:(UIView *) view inView:(UIView*) contentView
{
    NSDictionary * viewsDictionary = @{
                                       @"view": view
                                       };
    NSDictionary * metrics = @{
                               @"topMargin":[NSNumber numberWithInt:4],
                               @"leftMargin":[NSNumber numberWithInteger:leftMargin],
                               @"rightMargin":[NSNumber numberWithInteger:rightMargin]
                               };
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[view]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[view]-rightMargin-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    
    
    [contentView addConstraints:constraint_POS_H];
    [contentView addConstraints:constraint_POS_V];

}

+(void)applyEqualConstraint:(NSInteger)leftMargin andRightMargin:(NSInteger)rightMargin spaceInBetween:(NSInteger)space viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *) contentView;
{
    NSDictionary * viewsDictionary = @{
                                       @"leftView": leftView,
                                       @"rightView":rightView
                                       };
    NSDictionary * metrics = @{
                               @"topMargin": [NSNumber numberWithInt:4],
                               @"leftMargin": [NSNumber numberWithInteger:leftMargin],
                               @"rightMargin":[NSNumber numberWithInteger:rightMargin],
                               @"space":[NSNumber numberWithInteger:space]
                               };
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[leftView]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[leftView]-space-[rightView(==leftView)]-rightMargin-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictionary];
    
    
    [contentView addConstraints:constraint_POS_H];
    [contentView addConstraints:constraint_POS_V];
    
}

+(void)applyHeightConstaint:(NSInteger)height forView:(UIView *)view
{
    NSDictionary * viewsDictionary = @{
                                      @"view": view
                                      };
    NSDictionary * metrics = @{
                               @"height": [NSNumber numberWithInteger:height]
                               };
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(height)]"
                                                                    options:0
                                                                    metrics:metrics
                                                                      views:viewsDictionary];
    [view addConstraints:constraint_V];
}
+(void)applyWidthConstraint:(NSInteger)width forView:(UIView *)view
{
    NSDictionary * viewsDictionary = @{
                                       @"view": view
                                       };
    NSDictionary * metrics = @{
                               @"width": [NSNumber numberWithInteger:width]
                               };
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(width)]"
                                                                    options:0
                                                                    metrics:metrics
                                                                      views:viewsDictionary];
    [view addConstraints:constraint_H];
    
}

+(void)applyLeftFlexibleConstraint:(NSInteger) leftMargin spaceInBetween:(NSInteger) space rightMargin:(NSInteger)rightMargin viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *)contentView
{
    NSDictionary * viewsDictionary = @{
                                       @"leftView": leftView,
                                       @"rightView":rightView
                                       };
    NSDictionary * metrics = @{
                               @"topMargin":[NSNumber numberWithInt:4],
                               @"leftMargin": [NSNumber numberWithInteger:leftMargin],
                               @"rightMargin":[NSNumber numberWithInteger:rightMargin],
                               @"space":[NSNumber numberWithInteger:space]
                               };
    NSArray * constraint_pos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[leftView]" options:0 metrics:metrics views:viewsDictionary];
    
    NSArray * constrain_pos_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[leftView]-space-[rightView]-rightMargin-|" options:0 metrics:metrics views:viewsDictionary];
    [contentView addConstraints:constrain_pos_H];
    [contentView addConstraints:constraint_pos_V];
}

+(void)applyRightFexileConstraint:(NSInteger)leftMargin spaceInBetween:(NSInteger)space rightMargin:(NSInteger)rightMargin viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *)contentView
{
    NSDictionary * viewsDictionary = @{
                                       @"leftView": leftView,
                                       @"rightView":rightView
                                       };
    NSDictionary * metrics = @{
                               @"topMargin": [NSNumber numberWithInt:4],
                               @"leftMargin": [NSNumber numberWithInteger:leftMargin],
                               @"rightMarin": [NSNumber numberWithInteger:rightMargin],
                                @"space":[NSNumber numberWithInteger:space]
                               };
    NSArray * constraint_pos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[leftView]" options:0 metrics:metrics views:viewsDictionary];
    
    NSArray * constrain_pos_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[leftView]-space-[rightView]-rightMarin-|" options:0 metrics:metrics views:viewsDictionary];
    [contentView addConstraints:constrain_pos_H];
    [contentView addConstraints:constraint_pos_V];
}

@end
