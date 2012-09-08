#import <UIKit/UIKit.h>

#import "LuBannAppAppDelegate.h"
#import "TabBarController.h"
#import "Three20/Three20.h"

@class PhotoTest2Controller;

@interface CatalogController : TTTableViewController{

	//controller della vista che dovrà essere aperta
	PhotoTest2Controller *photoController;
	TabBarController *tabBarController;

}
//@property (nonatomic, retain) UITabBarController *tabBarController;
 @property (nonatomic, retain) TabBarController *tabBarController;
@end
