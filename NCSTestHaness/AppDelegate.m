//
//  AppDelegate.m
//  NCSTestHaness
//
//  Created by Bass, Michael on 2/17/14.
//  Copyright (c) 2014 MSS. All rights reserved.
//

#import "AppDelegate.h"


#import <AssessmentModel/UUID.h>
#import <AssessmentModel/Instrument.h>
#import <AssessmentModel/ItemData.h>
/*
 
 #import <NCSFramework/UUID.h>
 #import <NCSFramework/Instrument.h>
 #import <NCSFramework/ItemData.h>
 */
@implementation AppDelegate


- (void)assessmentManagerViewControllerUserDidStartInstrument:(Instrument *)instrument{
    NSLog(@"starting %@", instrument.view);
}
- (void)assessmentManagerViewControllerUserDidFinishInstrument:(Instrument *)instrument{
    NSLog(@"finishing %@", instrument.view);
}
- (void)assessmentManagerViewControllerUserDidSaveItem:(Instrument *)instrument itemData:(ItemData *)itemData{
    NSLog(@"saving in instrument %@  ID: %@  Response:%@", instrument.view, itemData.ID, itemData.Response);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDate *now = [NSDate date];
    User* _user = [[User alloc] init];
    _user.uuid = [UUID generate];
    _user.dateCreated = now;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormat dateFromString:@"2000/01/01"];
    
    _user.title = @"Steve";
    _user.dob = date;
    _user.education = @"3rd grade";
    _user.language = @"Engish";
    _user.age    = [NSNumber numberWithInt:5];
    
    
    Assessment* assessment = [[Assessment alloc] init];
    
    // create valid assessment
    NSNumber *batteryType = [Assessment batteryTypes][1];
    
    assessment.title = [Assessment batteryTitleForBatteryType:batteryType];
    assessment.uuid = [UUID generate];
    assessment.dateCreated = now;
    assessment.type = batteryType;
    assessment.status = [NSNumber numberWithInteger:NCSAssessmentStatusScheduled];
    
    // create instruments and add to assessment
    NSMutableSet *instruments = [[NSMutableSet alloc] init];
    
    
    Instrument *instrument = [[Instrument alloc] init];
    instrument.uuid = [UUID generate];
    instrument.dateCreated = now;
    //instrument.type = instrumentType;
    instrument.index = [NSNumber numberWithInteger:0];
    instrument.view  = @"NCSPictureVocabularyPracticeInstrumentView";//@"NCSDCCSInstrumentView";
    [instruments addObject:instrument];
    
    Instrument *instrument3 = [[Instrument alloc] init];
    instrument3.uuid = [UUID generate];
    instrument3.dateCreated = now;
    //instrument.type = instrumentType;
    instrument3.index = [NSNumber numberWithInteger:1];
    instrument3.view  = @"NCSPictureVocabularyInstrumentView";//@"NCSDCCSInstrumentView";
    [instruments addObject:instrument3];
    
    
    Instrument *instrument2 = [[Instrument alloc] init];
    instrument2.uuid = [UUID generate];
    instrument2.dateCreated = now;
    //instrument.type = instrumentType;
    instrument2.index = [NSNumber numberWithInteger:2];
    instrument2.view  = @"NCSFlankerInstrumentView";
    [instruments addObject:instrument2];
    
    
    assessment.instruments = instruments;
    
    
    
    AssessmentManagerViewController *assessmentManagerViewController = [[AssessmentManagerViewController alloc] initWithUser:_user andAssessment:assessment];
    assessmentManagerViewController.delegate = self;
    //assessmentManagerViewController.managedObjectContext = _managedObjectContext;
    assessmentManagerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    /*
     _rootViewController = [[RootViewController alloc] init];
     [_rootViewController addChildViewController:assessmentManagerViewController];
     [_rootViewController.view addSubview:assessmentManagerViewController.view];
     */
    
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = assessmentManagerViewController;
    [self.window makeKeyAndVisible];
    
    //[_rootViewController presentViewController:assessmentManagerViewController animated:YES completion:nil];
    //[assessmentManagerViewController startAssessment];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - assessment manager view controller delegate

- (void)assessmentManagerViewControllerDidFinish:(AssessmentManagerViewController *)viewController
{
    Assessment *assessment = viewController.assessment;
    [self updateAssessmentStatus:assessment];
    
    // [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


- (void)assessmentManagerViewControllerUserDidLogOutDuringAssessment:(AssessmentManagerViewController *)viewController
{
    Assessment *assessment = viewController.assessment;
    [self updateAssessmentStatus:assessment];
}

- (void)updateAssessmentStatus:(Assessment *)assessment
{
    NSInteger complete = 0;
    NSInteger progress = 0;
    NSInteger upload = 0;
    
    /*
     for (Instrument *instrument in assessment.instruments) {
     // FIXME: hack to not count practice tests
     if ([instrument.title rangeOfString:@"Practice"].location == NSNotFound) {
     if (instrument.status.integerValue == NCSInstrumentStatusCompleted) complete++;
     if (instrument.status.integerValue == NCSInstrumentStatusInProgress) progress++;
     if (instrument.status.integerValue == NCSInstrumentStatusUploaded) upload++;
     }
     }
     */
    
    if (upload == assessment.instruments.count) {
        assessment.status = [NSNumber numberWithInteger:NCSAssessmentStatusUploaded];
    } else if (complete == assessment.instruments.count) {
        assessment.status = [NSNumber numberWithInteger:NCSAssessmentStatusCompleted];
    } else if (progress) {
        assessment.status = [NSNumber numberWithInteger:NCSAssessmentStatusInProgress];
    } else {
        assessment.status = [NSNumber numberWithInteger:NCSInstrumentStatusScheduled];
    }
    
    /*
     NSError *error;
     if (![self.fetchedResultsController.managedObjectContext save:&error]) {
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
     }
     */
}

@end
