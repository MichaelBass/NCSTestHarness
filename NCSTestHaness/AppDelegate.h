//
//  AppDelegate.h
//  NCSTestHaness
//
//  Created by Bass, Michael on 2/17/14.
//  Copyright (c) 2014 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssessmentModel/AssessmentManagerViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AssessmentManagerViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
