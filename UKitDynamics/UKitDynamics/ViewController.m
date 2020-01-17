//
//  ViewController.m
//  UKitDynamics
//
//  Created by CPU11716 on 1/14/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property UIDynamicAnimator *animator;
@property UIGravityBehavior *gravity;
@property UICollisionBehavior *collision;
@property UISnapBehavior *snap;
@property UIView *snapView;
@property BOOL isFirstContact;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *squareView =[[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    squareView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:squareView];
    
    UIView *barrierView =[[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrierView.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrierView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[squareView]];
    [self.animator addBehavior:self.gravity];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[squareView]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];
    
    CGPoint rightBarrierView = CGPointMake(barrierView.frame.origin.x + barrierView.frame.size.width, barrierView.frame.origin.y);
    [self.collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrierView.frame.origin toPoint:rightBarrierView];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[squareView]];
    itemBehavior.elasticity = 0.8;
    [self.animator addBehavior:itemBehavior];
    
    //for nap behavior
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    self.snapView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 50, 50)];
    self.snapView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.snapView];
    
    //push
    UIView *pushView = [[UIView alloc] initWithFrame:CGRectMake(20, 400, 50, 50)];
    pushView.backgroundColor = UIColor.brownColor;
    [self.view addSubview:pushView];
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[pushView] mode:UIPushBehaviorModeContinuous];
    push.angle = 0;
    push.magnitude = 0.3;
    [self.animator addBehavior:push];
    [self.collision addItem:pushView];
    
    self.collision.collisionDelegate = self;
    self.isFirstContact = NO;
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(nonnull id<UIDynamicItem>)item withBoundaryIdentifier:(nullable id<NSCopying>)identifier atPoint:(CGPoint)p {
    UIView *view =(UIView*) item;
    view.backgroundColor = [UIColor greenColor];
    [UIView animateWithDuration:0.2 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];
    
    if (!self.isFirstContact) {
        self.isFirstContact = YES;
        UIView * square = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 100, 100)];
        square.backgroundColor = [UIColor grayColor];
        [self.view addSubview:square];
        
        [self.collision addItem:square];
        [self.gravity addItem:square];
        
        UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:square];
        [self.animator addBehavior:attach];
    }
}

- (void)handleTap:(UITapGestureRecognizer*) gesture {
    CGPoint tapPoint = [gesture locationInView:self.view];
    if (self.snap != nil) {
        [self.animator removeBehavior:self.snap];
        NSLog(@"snap");
    }
    self.snap = [[UISnapBehavior alloc] initWithItem:_snapView snapToPoint:tapPoint];
    [self.animator addBehavior:self.snap];
}
@end
