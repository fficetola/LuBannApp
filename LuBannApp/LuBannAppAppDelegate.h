//
//  LuBannAppAppDelegate
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ForumViewController.h"
#import "FeedForumViewController.h"
//#import "ThirdViewController.h"
#import "CatalogController.h"
#import "Three20/Three20.h"

@class ForumViewController;
@class FeedForumViewController;
@class ThirdViewController;
@class CatalogController;

@interface LuBannAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
    //NSString *deviceToken;
	NSMutableString *idBoard;
	NSMutableString *idTopic;
	NSMutableString *idPost;
	NSMutableString *idSection;
    NSMutableString *titleCategory;
    NSMutableString *titleTopic;
    NSMutableString *titlePost;
    NSMutableString *path;
    NSMutableString *title;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;


@property (nonatomic, retain) NSMutableString *idBoard;
@property (nonatomic, retain) NSMutableString *idTopic;
@property (nonatomic, retain) NSMutableString *idPost;
@property (nonatomic, retain) NSMutableString *idSection;
@property (nonatomic, retain) NSMutableString *titleCategory;
@property (nonatomic, retain) NSMutableString *titleTopic;
@property (nonatomic, retain) NSMutableString *titlePost;
@property (nonatomic, retain) NSMutableString *path;
@property (nonatomic, retain) NSMutableString *title;
//@property (nonatomic, retain) NSString *deviceToken;

@end
