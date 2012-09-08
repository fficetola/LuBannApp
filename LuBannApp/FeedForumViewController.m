//
//  FirstViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "FeedForumViewController.h"
#import "SinglePostViewController.h"
#import "FeedForumCellView.h"
#import "Utils.h"
#import "ASIHTTPRequest.h"


@implementation FeedForumViewController

@synthesize appDelegate;
@synthesize tblCell;
@synthesize spinner;
@synthesize progressAlert;




- (void)parseXMLFileAtURL:(NSData *) responseData {
    // inizializziamo la lista degli elementi
	elencoFeed = [[NSMutableArray alloc] init];
    
	// dobbiamo convertire la stringa "URL" in un elemento "NSURL"
	//NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// inizializziamo il nostro parser XML
	rssParser = [[NSXMLParser alloc] initWithData:responseData];
	
	[rssParser setDelegate:self];
	
	// settiamo alcune proprietà
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	// avviamo il parsing del feed RSS
	[rssParser parse];
    
    //aggiorno la tableview
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [spinner stopAnimating];
    [progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching binary data
    NSString *error = nil;
    NSData *responseData = [request responseData];
    if (!responseData) {  
        NSLog(@"Error reading plist from file , error = '%s'",  [error UTF8String]);  
        [error release];  
        
        //inizializzo a 0
        elencoFeed = [[NSMutableArray alloc] initWithCapacity:0];

        
    }else{
        [self parseXMLFileAtURL:responseData];
    }
    
    

    
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

    
    NSString *URL = @"http://www.lubannaiuolu.net/forum/index.php?type=rss&action=.xml;limit=20";
    
    NSURL *url = [NSURL URLWithString:URL];
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

- (void) viewDidLoad{
    
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
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];	
        
        self.title = @"Ultime news";
    
    //chiamo soltanto una volta
    if(elencoFeed==nil || [elencoFeed count]==0)[self loadData];
        
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Load up the sitesArray with a dummy array : sites
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// inizializza tutti gli elementi
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
        currentAuthor = [[NSMutableString alloc] init];
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	
	if ([elementName isEqualToString:@"item"]) {
		/* salva tutte le proprietà del feed letto nell'elemento "item", per
		 poi inserirlo nell'array "elencoFeed" */
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"description"];
		[item setObject:currentDate forKey:@"pubDate"];
        [item setObject:currentAuthor forKey:@"author"];
		
        NSMutableDictionary *itemCopy = [[NSMutableDictionary alloc] initWithDictionary:item];
		[elencoFeed addObject:itemCopy];
        [itemCopy release];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{;
	// salva i caratteri per l'elemento corrente
	if ([currentElement isEqualToString:@"title"]){
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}else if ([currentElement isEqualToString:@"author"]) {
        [currentAuthor appendString:string];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
	[self.tableView reloadData];
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


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return YES;
 }
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [elencoFeed count];
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
    
    //static NSString *CellIdentifier = @"Cell";
    
/*    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
*/
    //CELLA CUSTOM
	FeedForumCellView *cell = (FeedForumCellView *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"FeedForumCellView" owner:self options:nil];
		cell = tblCell;
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
     NSMutableString *pubDate = [[NSMutableString alloc] initWithString:(NSMutableString *)[[elencoFeed objectAtIndex:indexPath.row] objectForKey:@"pubDate"]];
    //[pubDate substringWithRange:NSMakeRange(0, 26)];
    [pubDate replaceCharactersInRange: [pubDate rangeOfString: @"\n\t\t\t"] withString: @""];
    [pubDate replaceCharactersInRange: [pubDate rangeOfString: @" GMT"] withString: @""];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];

    // set locale to something English
    NSLocale *enLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease];
    [dateFormat1 setLocale:enLocale];
    
    NSDate *date = [dateFormat1 dateFromString:pubDate];
    
    UIImage *icon = [UIImage imageNamed:@"rss_rosa.png"];  
    
    if(indexPath.row%2 == 0){
         icon = [UIImage imageNamed:@"rss_verde.png"];  
    }
       
    
	[[cell imageView] setImage:icon];
    
	// Configure the cell.
	cell.cellText.text = [[elencoFeed objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailText.text = [[elencoFeed objectAtIndex:indexPath.row] objectForKey:@"author"];
    
	 
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"dd.MM.yyyy, HH:mm"];
    cell.lastUpdateText.text = [dateFormat2 stringFromDate:date];
	                              
    [dateFormat1 release]; [dateFormat2 release];
    [pubDate release];
   // [date release];
	return cell;
}




// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// ricaviamo il link dell'elemento selezionato
	/*NSString *link = [[elencoFeed objectAtIndex:indexPath.row] objectForKey: @"link"];
	
	// ripiliamo il link da spazi, return e tabs
	link = [link stringByReplacingOccurrencesOfString:@" " withString:@""];
	link = [link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	link = [link stringByReplacingOccurrencesOfString:@"	" withString:@""];
	
	// apriamo la notizia in Safari
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
	 */
	
	NSString *link = [[elencoFeed objectAtIndex:indexPath.row] objectForKey: @"link"];
	
	
	//pezzotto per recuperare l'ID del post:
	NSArray *chunks = [link componentsSeparatedByString: @"#"];
	NSMutableString *idPost = [[NSMutableString alloc] initWithString:(NSMutableString *)[chunks objectAtIndex:1]];

	appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	[idPost replaceCharactersInRange: [idPost rangeOfString: @"\n\t\t\t"] withString: @""];
	[idPost replaceCharactersInRange: [idPost rangeOfString: @"msg"] withString: @""];
	appDelegate.idPost = idPost;
	
	viewSinglePost = [[SinglePostViewController alloc] initWithNibName:@"SinglePostView" bundle:[NSBundle mainBundle]];
	
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewSinglePost animated:YES];
	
	//rilasciamo il controller
    [viewSinglePost release];
	viewSinglePost = nil;
    
   /* decremento il badge
    [UIApplication sharedApplication].applicationIconBadgeNumber =  [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
    
    self.navigationController.tabBarItem.badgeValue =  [NSString stringWithFormat:@"%i", [UIApplication sharedApplication].applicationIconBadgeNumber];
    */
   
    [idPost release];
    
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
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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



- (void)dealloc {
	[currentElement release];
	[rssParser release];
	[elencoFeed release];
	[item release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
    [spinner dealloc];
    [progressAlert dealloc];
	
    [super dealloc];
}


@end

