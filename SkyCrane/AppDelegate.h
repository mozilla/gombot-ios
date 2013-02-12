//
//  AppDelegate.h
//  SkyCrane
//
//  Created by Dan Walkowski on 11/9/12.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PINViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  NSTimer* dataRefreshTimer;
  NSString* lastCopy;
  
  UIBackgroundTaskIdentifier backgroundUpdateTask;
  
  NSOperationQueue *backgroundQueue;
  NSInvocationOperation *clearClipboardOperation;
  NSInvocationOperation *lockDBOperation;
  PINViewController* pinController;
  BOOL needPinOnWake;
}

- (void) setLastCopyValue: (NSString*)clipContents;
- (void) setPinControl: (PINViewController*)pin;

@property (strong, nonatomic) UIWindow *window;

@end
