//
//  LuBannAppAppDelegate
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "LuBannAppAppDelegate.h"
#import "TabBarController.h"


@implementation LuBannAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize idBoard;
@synthesize idTopic;
@synthesize idPost;
@synthesize idSection;
@synthesize titleCategory;
@synthesize titleTopic;
@synthesize titlePost;
@synthesize path;
@synthesize title;
//@synthesize deviceToken;




#pragma mark -
#pragma mark Application lifecycle

/*
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
 // Override point for customization after application launch.
 
 // Add the tab bar controller's view to the window and display.
 [window addSubview:tabBarController.view];
 [window makeKeyAndVisible];
 
 return YES;
 }
 */


//////////////////////////////////////////////
// CLIENT SIDE CODE
//////////////////////////////////////////////
/*- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString *deviceToken = [[[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //In below methods, deviceToken pass to register device on Web service that send push notification.
    //[self saveToUserDefaults:self.deviceToken];
    
    NSLog(@"%@",deviceToken);
    
    NSString *host = @"www.lubannaiuolu.net/lubannapp";
    NSString *URLString = @"/pushnotifierregister.php?";
    URLString = [URLString stringByAppendingString:@"devicetoken="];
    
    URLString = [URLString stringByAppendingString:deviceToken];
    URLString = [URLString stringByAppendingString:@"&devicename="];
    URLString = [URLString stringByAppendingString:[[UIDevice alloc] uniqueIdentifier]];
    
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:URLString];
    NSLog(@"FullURL=%@", url);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //rimuovo il badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

//this method is call when applcation is running and notification is come.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    // Do whatever when application receive notification that will written in this method.
    
       
    //rimuovo il badge
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    tabBarController.selectedIndex = 1;
    NSString *badgeValue = [NSString stringWithFormat:@"%i", [UIApplication sharedApplication].applicationIconBadgeNumber];
    tabBarController.selectedViewController.tabBarItem.badgeValue=badgeValue;
}

*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
	// Allow downloading images as big as we want!  :P
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    NSLog(@"didFinishLaunchingWithOptions");
    
	
    /*	TTNavigator* navigator = [TTNavigator navigator];
     navigator.supportsShakeToReload = YES;
     navigator.persistenceMode = TTNavigatorPersistenceModeAll;
     
     TTURLMap* map = navigator.URLMap;
     //[map from:@"tt://tabBar"  toSharedViewController:[TabBarController class]];
     
     [map from:@"*" toViewController:[TTWebController class]];
     */
    /*	if (TTIsPad()) {
     [map                    from: @"tt://catalog"
     toSharedViewController: [SplitCatalogController class]];
     
     SplitCatalogController* controller =
     (SplitCatalogController*)[[TTNavigator navigator] viewControllerForURL:@"tt://catalog"];
     TTDASSERT([controller isKindOfClass:[SplitCatalogController class]]);
     map = controller.rightNavigator.URLMap;
     
     } else {
     */
	// [map from:@"tt://tabBar" toSharedViewController:[TabBarController class]];
    
	/*[map                    from: @"tt://catalog"
     toSharedViewController: [CatalogController class]];
     */
    
    /*
	 }
	 [map            from: @"tt://photoTest1"
	 parent: @"tt://catalog"
	 toViewController: [PhotoTest1Controller class]
	 selector: nil
	 transition: 0];
	 
	 */
    /*[map            from: @"tt://photoTest2"
     parent: @"tt://catalog"
     toViewController: [PhotoTest2Controller class]
     selector: nil
     transition: 0];
     */
	
	/*if (![navigator restoreViewControllers]) {
	 [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://catalog"]];
	 }
     */
	
	// set up tab bar controller manually
    /*tabBarController = [[UITabBarController alloc] init];
     forumViewController = [[ForumViewController alloc] init];
     feedForumViewController = [[FeedForumViewController alloc] init];
     catalogController = [[CatalogController alloc] init]; */
	
    /* This is the essential part of the solution. You have to add the albumController to a
	 new  navigation controller and init it as RootViewController*/
    //UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:catalogController] autorelease];
	
    // now add all controllers to the tabBarController
    //NSArray *viewControllers = [self.tabBarController viewControllers];
	
	//tabBarController.viewControllers = [NSArray arrayWithObjects:catalogController, navController, nil];
	
  	// Add the tab bar controller's view to the window and display.
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    
	
	return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	//TTOpenURL([URL absoluteString]);
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


/*
 
 // Delegation methods
 - (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
 const void *devTokenBytes = [devToken bytes];
 // self.registered = YES;
 //  [self sendProviderDeviceToken:devTokenBytes]; // custom method
 }
 
 - (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
 NSLog(@"Error in registration. Error: %@", err);
 }
 
 */


- (void)dealloc {
    [tabBarController release];
    [window release];
    [idBoard release];
    [idTopic release];
    [idPost release];
    [titleCategory release];
    [titleTopic release];
    [titlePost release];
    [path release];
    [title release];
    //[deviceToken release];
	[super dealloc];
	
}

@end

