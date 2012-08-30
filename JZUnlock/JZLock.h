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

@protocol JZLockDelegate <NSObject>

- (UIImage*)imageForState:(JZLockState)state;

@end

@interface JZLock : UIView

//- (id)initWithFrame:(CGRect)frame
//           andImage:(UIImage*)image;
- (id)initWithFrame:(CGRect)frame
       lockDelegate:(id<JZLockDelegate>)lockDelegate;

@property (nonatomic, weak) id<JZLockDelegate>lockDelegate;

- (void)changeState:(JZLockState)state animated:(BOOL)animated;

@end
