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
    JZLockStateSelected,
    JZLockStateInvalid
} JZLockState;

@protocol JZLockDelegate <NSObject>

- (UIImage*)imageForState:(JZLockState)state;

@end

@interface JZLock : UIView

- (id)initWithFrame:(CGRect)frame
       lockDelegate:(id<JZLockDelegate>)lockDelegate
           lockData:(id)lockData;

@property (nonatomic, weak) id<JZLockDelegate>lockDelegate;
@property (nonatomic, strong) id lockData;

- (void)changeState:(JZLockState)state animated:(BOOL)animated;

@end
