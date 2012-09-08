//
//  PostViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 01/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "PostViewController.h"
#import "SinglePostViewController.h"
#import "PostCellView.h"
#import "LuBannAppAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"


@implementation PostViewController

@synthesize listaPosts;
@synthesize appDelegate;

@synthesize tblCell;
@synthesize progressAlert;
@synthesize spinner;


#pragma mark -
#pragma mark View lifecycle

- (void) loadData {
    
    
    //[Utils testConnectionThread];
    
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Caricamento dati"
                                               message:@"Attendere prego..."
                                              delegate: self
                                     cancelButtonTitle: nil
                                     otherButtonTitles: nil];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
    [progressAlert addSubview:spinner];
    [spinner startAnimating];
    
    [progressAlert show];
    [progressAlert release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
    /* Operation Queue init (autorelease) */
    
    //PRIMA ALTERNATIVA
    /* NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
     [NSThread sleepForTimeInterval:2];
     [self performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:NO];
     [pool release];
     */
    appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *indirizzo = @"http://www.lubannaiuolu.net/lubannapp/getPosts.php?id_topic=";
	indirizzo = [indirizzo stringByAppendingString:appDelegate.idTopic];
	
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    //SECONDA ALTERNATIVA
    /*NSOperationQueue *queue = [NSOperationQueue new];
     
     
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
     selector:@selector(caricaListaGallery)
     object:nil];
     
     [queue addOperation:operation];
     [operation release];
     */
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching binary data
    NSString *error = nil;
    NSData *responseData = [request responseData];
    if (!responseData) {  
        NSLog(@"Error reading plist from file , error = '%s'",  [error UTF8String]);  
        [error release];  
        
        //inizializzo a zero
        listaPosts = [[NSMutableArray alloc] initWithCapacity:0];
    }  
    else{
    
        listaPosts = [[NSMutableArray alloc] initWithArray:[Utils readPlist:responseData]];
    }
    
        
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    //tolgo lo spinner 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [spinner stopAnimating];
    [progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (error != nil) { 
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Errore di rete" message: @"Connettività ad Internet limitata o assente!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        [someError release];  
        
        //tolgo lo spinner 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [spinner stopAnimating];
        [progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
        
    } 
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Posts";
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView* hiddenView = [[UIView alloc] initWithFrame:frame];
    hiddenView.autoresizingMask = (
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin
                                   );

    hiddenView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"bannabackground.png"]];
    [self.tableView addSubview:hiddenView];
    [hiddenView release];

    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"update_20.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    [self loadData];
    
	
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [listaPosts count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:1 green:.76 blue:1 alpha:1]];
    }
    else [cell setBackgroundColor:[UIColor colorWithRed:.9 green:.96 blue:.81 alpha:1]];
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// static NSString *CellIdentifier = @"Cell";
	
    
    NSDictionary *cellData = [listaPosts objectAtIndex:indexPath.row];
	//NSString *dataKey = [cellData objectForKey:@"id"];
	//NSString *cellType = [cellData objectForKey:@"id"];
    
	/*UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cellID"] autorelease];
		//setta lo stile con cui vengono selezionate le righe
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
     */
    
    
	//CELLA CUSTOM
	PostCellView *cell = (PostCellView *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"PostCellView" owner:self options:nil];
		cell = tblCell;
	}

	
	// Impostiamo la datakey della cella
	//cell.dataKey = dataKey;
	
	cell.cellText.text = [cellData objectForKey:@"name"];
	
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy, HH:mm"];
    NSDate *date = [dateFormat dateFromString:[cellData objectForKey:@"posterTime"]]; 
    
    NSDate *now = [NSDate date];
    
    now = [now dateByAddingTimeInterval: -60*60*24*7];  // meno di 7 giorni
    
    
    NSComparisonResult result = [now compare:date];
    
    UIImage *icon = nil;
    switch (result)
    {
        case NSOrderedAscending: 
            icon = [UIImage imageNamed:@"newmail.png"];            
            break;
        case NSOrderedDescending: 
            icon = [UIImage imageNamed:@"mail.png"];
            break;
        case NSOrderedSame: 
            icon = [UIImage imageNamed:@"newmail.png"];    
            break;
        default:  
            icon = [UIImage imageNamed:@"mail.png"];
            break;
    }
    
    
	[[cell imageView] setImage:icon];
	//[cell setDetailText:[NSString stringWithFormat:@"This is row: %i", row + 1]];
	
    cell.detailText.text = [cellData objectForKey:@"memberName"];
    cell.lastUpdateText.text = [cellData objectForKey:@"posterTime"];
    //cell.detailText.text = [NSString stringWithFormat:@"This is row: %i", row + 1];
    
	
    
    //cell.backgroundColor = [UIColor grayColor];
    // else cell.backgroundColor = [UIColor whiteColor];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [dateFormat release];
    

	
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return appDelegate.titleTopic;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *cellData = [listaPosts objectAtIndex:indexPath.row];
	/*UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:@"Hai selezionato:" message:[cellData objectForKey:@"id"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [popUp show];
	 [popUp release];
	*/
	
	NSMutableString *idPost = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"id"]];
	//idBoard = [cellData objectForKey:@"id"];
	
	appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.idPost = idPost;
	
	viewSinglePost = [[SinglePostViewController alloc] initWithNibName:@"SinglePostView" bundle:[NSBundle mainBundle]];
	
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewSinglePost animated:YES];
	
	//rilasciamo il controller
	[viewSinglePost release];
	 viewSinglePost = nil;
	
	[idPost release];
	
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}


- (void)dealloc {
	[listaPosts dealloc];
    [super dealloc];
}


@end

