//
//  JZUnlockView.h
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZLock.h"

@class JZUnlockView;

typedef enum {
    JZUnlockPattern2x2 = 0,
    JZUnlockPattern3x3 = 1,
    JZUnlockPattern4x4 = 2,
} JZUnlockPattern;

@protocol JZUnlockViewDelegate <NSObject>

- (void)lockViewDidBeginUnlocking:(JZUnlockView*)unlockView andLock:(UIView*)lock;
- (void)lockViewDidEndUnlocking:(JZUnlockView*)unlockView;
- (BOOL)lockViewCanBeginUnlocking:(JZUnlockView*)unlockView andLock:(UIView*)lock;

@end

@interface JZUnlockView : UIView <UIGestureRecognizerDelegate, JZLockDelegate>

- (id)initWithFrame:(CGRect)frame
         andPattern:(JZUnlockPattern)pattern
    unlockViewDelegate:(id<JZUnlockViewDelegate>)unlockDelegate;

- (void)setImage:(UIImage*)image forState:(JZLockState)state;
- (void)lockActivated:(UIView*)lock;
- (void)drawLine:(NSArray*)points;
- (UIView*)lockWith:(CGPoint)point;
- (void)cleanup;

@end