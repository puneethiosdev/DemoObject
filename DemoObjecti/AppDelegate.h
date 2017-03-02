//
//  AppDelegate.h
//  DemoObjecti
//
//  Created by Puneeth Kumar  on 27/12/16.
//  Copyright © 2016 ASM Technologies Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

