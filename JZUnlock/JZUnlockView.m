//
//  JZUnlockView.m
//  JZUnlock
//
//  Created by Jure Žove on 8/30/12.
//  Copyright (c) 2012 Jure Žove. All rights reserved.
//

#import "JZUnlockView.h"


@interface JZUnlockView() {
    NSArray *points;
    BOOL isUnlocking;
}

@property (nonatomic, strong) NSArray *locks;
@property (nonatomic, weak) id<JZUnlockViewDelegate>unlockDelegate;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) NSMutableArray *activeLocks;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSMutableDictionary *images;

@end

@implementation JZUnlockView

//@synthesize gestureDelegate = _gestureDelegate;
@synthesize unlockDelegate = _unlockDelegate;
@synthesize pan = _pan;
@synthesize activeLocks = _activeLocks;
@synthesize images = _images;

- (id)initWithFrame:(CGRect)frame
         andPattern:(JZUnlockPattern)pattern
 unlockViewDelegate:(id<JZUnlockViewDelegate>)unlockDelegate {
    if (self = [super initWithFrame:frame]) {
        self.unlockDelegate = unlockDelegate;
        [self drawForPattern:pattern];
        self.backgroundColor = [UIColor whiteColor];
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.pan.delegate = self;
        [self addGestureRecognizer:self.pan];
        
        self.activeLocks = [[NSMutableArray alloc] initWithCapacity:16];
        self.images = [NSMutableDictionary dictionaryWithCapacity:3];
        self.lineColor = [UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (points.count > 0)
        draw1PxStroke(context, points, self.lineColor.CGColor);
}

- (void)drawForPattern:(JZUnlockPattern)pattern {
    int numOfRowsNCols = 0;
    switch (pattern) {
        case JZUnlockPattern3x3:
            numOfRowsNCols = 3;
            break;
        case JZUnlockPattern4x4:
            numOfRowsNCols = 4;
            break;
        case JZUnlockPattern2x2:
            numOfRowsNCols = 2;
            break;
    }
    float widthOfLock = 70.0f;
    float lockGap = CGRectGetWidth(self.frame) / (numOfRowsNCols);
    float verticalStart = (CGRectGetHeight(self.frame) - CGRectGetWidth(self.frame)) / 2;
    float horizontalStart = lockGap / 2 - widthOfLock / 2;
    
    float x;
    float y = verticalStart + horizontalStart;
    
    NSMutableArray *mutableLocks = [NSMutableArray arrayWithCapacity:numOfRowsNCols*numOfRowsNCols];
    for (int currentRow = 1; currentRow <= numOfRowsNCols; currentRow++) {
        x = horizontalStart;
        for (int currentCol = 1; currentCol <= numOfRowsNCols; currentCol++) {
            CGRect lockRect = CGRectMake(x,
                                         y,
                                         widthOfLock,
                                         widthOfLock);
            JZLock *lock = [[JZLock alloc] initWithFrame:lockRect
                            lockDelegate:self];
//            [lock setImage:[UIImage imageNamed:@"lock_normal"] forState:JZLockStateNormal];
//            [lock setImage:[UIImage imageNamed:@"lock_invalid"] forState:JZLockStateInvalid];
//            [lock setImage:[UIImage imageNamed:@"lock_valid"] forState:JZLockStateValid];
//            [lock changeState:JZLockStateNormal animated:NO];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
            longPress.minimumPressDuration = 0;
            longPress.delegate = self;
            [lock addGestureRecognizer:longPress];
            [self addSubview:lock];
            [mutableLocks addObject:lock];
            x += lockGap;
        }
        y += lockGap;
    }
    self.locks = [NSArray arrayWithArray:mutableLocks];
}

- (void)lockActivated:(UIView*)lock {
    [(JZLock*)lock changeState:JZLockStateValid animated:YES];
}

- (void)cleanup {
    for (UIView *lock in self.locks) {
        [(JZLock*)lock changeState:JZLockStateNormal animated:NO];
    }
}

- (void)startUnlocking {
    self.lineColor = [UIColor greenColor];
    [self cleanup];
    isUnlocking = YES;
}

- (void)finishUnlocking {
    isUnlocking = NO;
//    if (self.activeLocks.count == 1)
//        [self cleanup];

    self.lineColor = [UIColor redColor];
    for (JZLock *lock in self.activeLocks) {
        [lock changeState:JZLockStateInvalid animated:NO];
    }

    [self.activeLocks removeAllObjects];
    
}

- (UIView *)lockWith:(CGPoint)point {
    for (UIView* lock in self.locks) {
        if (CGRectContainsPoint(lock.frame, point)) {
            return lock;
        }
    }
    return nil;
}

- (void)setImage:(UIImage *)image forState:(JZLockState)state {
    [self.images setObject:image forKey:[NSNumber numberWithInt:state]];
}

- (void)layoutSubviews {
    for (JZLock *lock in self.locks)
        [lock changeState:JZLockStateNormal animated:NO];
}

#pragma mark - JZLockDelegate

- (UIImage *)imageForState:(JZLockState)state {
    return [self.images objectForKey:[NSNumber numberWithInt:state]];
}

#pragma mark - Drawing

- (void)drawLine:(NSArray *)points_ {
    points = points_;
    [self setNeedsDisplay];
}

void draw1PxStroke(CGContextRef context, NSArray* points,
                   CGColorRef color) {
    if (points.count < 1)
        return;
    
    CGContextSetLineWidth(context, 20.0);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextBeginPath(context);
    
    CGPoint startPoint = [[points objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    for (int i = 1; i < points.count; i++) {
        CGPoint nextPoint = [[points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
    }
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextStrokePath(context);
}

#pragma mark - Gestures

- (void)handlePan:(UIGestureRecognizer*)pan {
    CGPoint locationInView = [pan locationInView:self];
    UIView *lock = [self lockWith:locationInView];
    if (pan.state == UIGestureRecognizerStateBegan && self.activeLocks.count == 0) {
        if (!isUnlocking && lock && ![self.activeLocks containsObject:lock]) {
            [self startUnlocking];
            [self.activeLocks addObject:lock];
            [self lockActivated:lock];
            [self drawLine:@[ [NSValue valueWithCGPoint:lock.center] ]];
        }
    } else if (self.activeLocks.count > 0) {
        // Add other views
        if (lock && ![self.activeLocks containsObject:lock]) {
            [self lockActivated:lock];
            [self.activeLocks addObject:lock];
        }
        
        NSMutableArray *points_ = [NSMutableArray arrayWithCapacity:self.activeLocks.count+1];
        for (UIView *lock in self.activeLocks) {
            [points_ addObject:[NSValue valueWithCGPoint:lock.center]];
        }
        
        if (pan.state != UIGestureRecognizerStateEnded && pan.state != UIGestureRecognizerStateCancelled)
            [points_ addObject:[NSValue valueWithCGPoint:locationInView]];
        
        [self drawLine:points_];
        if ((pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) && isUnlocking) {
            [self finishUnlocking];
        }
    }
}

- (void)handlePress:(UIGestureRecognizer*)press {
    if (self.activeLocks.count == 0 && press.state == UIGestureRecognizerStateBegan) {
        [self handlePan:press];
    }
    else if (self.activeLocks.count > 0 && (press.state == UIGestureRecognizerStateEnded || press.state == UIGestureRecognizerStateCancelled)) {
        [self handlePan:press];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
