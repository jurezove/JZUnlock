//
//  JZLock.h
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JZLockStateNormal = 0,
    JZLockStateValid,
    JZLockStateInvalid
} JZLockState;

@interface JZLock : UIView

//- (id)initWithFrame:(CGRect)frame
//           andImage:(UIImage*)image;
- (void)setImage:(UIImage*)image forState:(JZLockState)state;
- (void)changeState:(JZLockState)state animated:(BOOL)animated;

@end
