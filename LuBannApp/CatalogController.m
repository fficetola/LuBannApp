#import "CatalogController.h"
#import "LuBannAppAppDelegate.h"
#import "PhotoTest2Controller.h"
#import "TabBarController.h"

@implementation CatalogController
@synthesize tabBarController;
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Foto";
    self.navigationItem.backBarButtonItem =
      [[[UIBarButtonItem alloc] initWithTitle:@"Foto" style:UIBarButtonItemStyleBordered
      target:nil action:nil] autorelease];
	  
	
		  self.tableViewStyle = UITableViewStyleGrouped;
	  	 	  
  }
  return self;
}

- (void) viewWillAppear: (BOOL) animated 
{ 
	[super viewWillAppear: animated]; 
	
	
	//[self.navigationController setToolbarHidden: YES animated: animated]; 
	
/*
	LuBannAppAppDelegate *appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.tabBarController == nil)
	{
		TabBarController *tabBar =  (TabBarController *) appDelegate.tabBarController;
		
		self.view = tabBar.view;
		
		
	}
	[self.navigationController pushViewController:self.tabBarController animated:YES];
 */
} 

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/* - (void)viewDidLoad {
   	

	 //self.tabBarController = appDelegate.tabBarController; 
	 self.hidesBottomBarWhenPushed = NO;
	 self.tabBarController.tabBar.hidden = NO;
	 
	 self.dataSource = [TTSectionedDataSource dataSourceWithObjects:@"Foto",
						
						//[TTTableTextItem itemWithText:@"Photo Browser" URL:@"tt://photoTest1"],
						
						[TTTableTextItem itemWithText:@"Thumbnails" URL:@"tt://photoTest2"],
						nil];
			
	 
 }
*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModelViewController

- (void)createModel {
  	
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:@"Foto",
    
	//[TTTableTextItem itemWithText:@"Photo Browser" URL:@"tt://photoTest1"],
    
	[TTTableTextItem itemWithText:@"Thumbnails" URL:@"tt://photoTest2"],

/*					 
    @"Styles",
    [TTTableTextItem itemWithText:@"Styled Views" URL:@"tt://styleTest"],
    [TTTableTextItem itemWithText:@"Styled Labels" URL:@"tt://styledTextTest"],

    @"Controls",
    [TTTableTextItem itemWithText:@"Buttons" URL:@"tt://buttonTest"],
    [TTTableTextItem itemWithText:@"Tabs" URL:@"tt://tabBarTest"],
    [TTTableTextItem itemWithText:@"Composers" URL:@"tt://composerTest"],

    @"Tables",
    [TTTableTextItem itemWithText:@"Table Items" URL:@"tt://tableItemTest"],
    [TTTableTextItem itemWithText:@"Table Controls" URL:@"tt://tableControlsTest"],
    [TTTableTextItem itemWithText:@"Styled Labels in Table" URL:@"tt://styledTextTableTest"],
    [TTTableTextItem itemWithText:@"Web Images in Table" URL:@"tt://imageTest2"],
    [TTTableTextItem itemWithText:@"Table With Banner" URL:@"tt://tableWithBanner"],
    [TTTableTextItem itemWithText:@"Table With Shadow" URL:@"tt://tableWithShadow"],
    [TTTableTextItem itemWithText:@"Table With Drag Refresh" URL:@"tt://tableDragRefresh"],

    @"Models",
    [TTTableTextItem itemWithText:@"Model Search" URL:@"tt://searchTest"],
    [TTTableTextItem itemWithText:@"Model States" URL:@"tt://tableTest"],

    @"General",
    [TTTableTextItem itemWithText:@"Web Image" URL:@"tt://imageTest1"],
    [TTTableTextItem itemWithText:@"YouTube Player" URL:@"tt://youTubeTest"],
    [TTTableTextItem itemWithText:@"Web Browser" URL:@"http://github.com/joehewitt/three20"],
    [TTTableTextItem itemWithText:@"Activity Labels" URL:@"tt://activityTest"],
    [TTTableTextItem itemWithText:@"Download Progress" URL:@"tt://dlprogress"],
    [TTTableTextItem itemWithText:@"Scroll View" URL:@"tt://scrollViewTest"],
    [TTTableTextItem itemWithText:@"Launcher" URL:@"tt://launcherTest"],
 */
    nil];
}

	

- (void)goHome:(id) sender {  
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	
}

@end
