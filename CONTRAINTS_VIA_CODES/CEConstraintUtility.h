//
//  CEViewUtility.h
//  EmrDemo
//
//  Created by Tacktile Systems on 7/15/14.
//  Copyright (c) 2014 Cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEConstraintUtility : NSObject
+(void)applyMatchParentConstraint:(NSInteger) leftMargin andRightMargin:(NSInteger) rightMargin forView:(UIView *) view inView:(UIView*) contentView;

+(void)applyEqualConstraint:(NSInteger)leftMargin andRightMargin:(NSInteger)rightMargin spaceInBetween:(NSInteger)space viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *)contentView;

+(void)applyHeightConstaint: (NSInteger) height forView:(UIView *)view;
+(void)applyWidthConstraint: (NSInteger) width forView:(UIView *)view;

+(void)applyLeftFlexibleConstraint:(NSInteger) leftMargin spaceInBetween:(NSInteger) space rightMargin:(NSInteger)rightMargin viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *)contentView;

+(void)applyRightFexileConstraint:(NSInteger)leftMargin spaceInBetween:(NSInteger)space rightMargin:(NSInteger)rightMargin viewOnLeft:(UIView *)leftView viewOnRight:(UIView *)rightView inView:(UIView *)contentView;
@end
