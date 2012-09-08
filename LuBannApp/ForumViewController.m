//
//  ForumViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 26/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "ForumViewController.h"
#import "TopicViewController.h"
#import "LuBannAppAppDelegate.h"
#import "TableCellView.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"


@implementation ForumViewController

@synthesize lista;
@synthesize listaOggetti;
@synthesize listaCategorie;
@synthesize appDelegate;

@synthesize tblCell;
@synthesize spinner;
@synthesize progressAlert;


#pragma mark -
#pragma mark View lifecycle


/*- (void)awakeFromNib{
	// creiamo la lista e inseriamo una serie di elementi da visualizzare nella nostra tabella
	lista = [[NSArray alloc] initWithObjects: @"iPhone", @"iPod",
			   @"iPod Touch", @"iMac", @"iBook", @"MacBook", @"MacBook Pro", @"Mac Pro", @"PowerBook", nil];
}
*/


- (id)initWithStyle:(UITableViewStyle)style { 
    if (self = [super initWithStyle:style]) { 
    } 
    return self; 
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
            listaCategorie = [[NSMutableArray alloc] initWithCapacity:0];
            listaOggetti = [[NSMutableArray alloc] initWithCapacity:0];
            
        } 
        else{
            
            //carico le categorie
            //NSString *indirizzoCategorie = @"http://www.lubannaiuolu.net/lubannapp/getCategories.php";
   
            //NSURL *urlCategorie = [NSURL URLWithString:indirizzoCategorie];
            listaCategorie = [[NSMutableArray alloc] initWithArray:[Utils readPlist:responseData]];     
    
            listaOggetti = [[NSMutableArray alloc] init];
    
    
            //scorro la lista delle categorie e recupero le board per ciascuna di esse
            for (int i=0; i<[listaCategorie count]; i++){
        
                NSDictionary *dictionaryCategoryTemp = [listaCategorie objectAtIndex:i];
                NSString *idCategory = [dictionaryCategoryTemp objectForKey:@"id"];
        
        
                //recupero la lista delle board per la categoria corrente
                //NSString *plisStructure = [[NSBundle mainBundle] pathForResource:@"data.plist"    ofType:nil];
                NSString *indirizzoBoard = @"http://www.lubannaiuolu.net/lubannapp/getBoards.php?idCategory=";
                indirizzoBoard = [indirizzoBoard stringByAppendingString:idCategory];
                //crea un oggetto URL
                // NSURL *urlBoard = [NSURL URLWithString:indirizzoBoard];
        
                lista = [[NSMutableArray alloc]initWithArray:[Utils downloadPlist:indirizzoBoard]];
        
                //lista = [[NSMutableArray alloc]initWithContentsOfFile:plisStructure];
                NSDictionary *dictBoard = [NSDictionary dictionaryWithObject:lista forKey:@"Elementi"];
        
                [listaOggetti addObject:dictBoard];
        
            }
        }
    
        //appena mi arrivano i dati refresho la lista
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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



- (void) caricaListaForum{
    
    NSURL *url = [NSURL URLWithString:@"http://www.lubannaiuolu.net/lubannapp/getCategories.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    
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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:2];
    [self performSelectorOnMainThread:@selector(caricaListaForum) withObject:nil waitUntilDone:NO];
    [pool release];
    
    //SECONDA ALTERNATIVA
    /*NSOperationQueue *queue = [NSOperationQueue new];
     
     
     NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
     selector:@selector(caricaListaGallery)
     object:nil];
     
     [queue addOperation:operation];
     [operation release];
     */
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //inserisco il pulsante di refresh
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"update_20.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
}

- (void)awakeFromNib{
   /*  UIImageView *background = [[UIImageView alloc]initWithImage: [UIImage imageNamed: @"Default.png"]];
    [self.tableView addSubview: background];
    [self.tableView sendSubviewToBack: background];


    
    [background release];

   UIView *hiddenView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)] autorelease];
    hiddenView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
    
    [self.tableView addSubview:hiddenView];*/
    //UIView *hiddenView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)] autorelease];
    /* self.tableView.backgroundColor =[UIColor colorWithPatternImage: [UIImage imageNamed: @"bannabackground.png"]];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;*/
    
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView* hiddenView = [[UIView alloc] initWithFrame:frame];
    hiddenView.backgroundColor = [UIColor whiteColor];

    hiddenView.autoresizingMask = (
                               UIViewAutoresizingFlexibleLeftMargin |
                               UIViewAutoresizingFlexibleRightMargin
                               );

    hiddenView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"bannabackground.png"]];
    
    [self.tableView addSubview:hiddenView];
    [hiddenView release];

    
   // [self.tableView addSubview:hiddenView];
    
    [self loadData];  // Loads data in table view
       
    self.navigationItem.title = @"LuB@nn@Forum";
	
}



/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    // Return YES for supported orientations
    return YES;
}


#pragma mark -
#pragma mark Table view data source

//setta il numero di sezioni della tabella
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
        return [listaOggetti count];
    
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dictionary = [listaOggetti objectAtIndex:section];
     NSArray *array = [dictionary objectForKey:@"Elementi"];
    //[dictionary release];
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSDictionary *dictionaryCategories = [listaCategorie objectAtIndex:section];
	NSString *titleCategories = [dictionaryCategories objectForKey:@"name"];
    
    return titleCategories;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	
    
    switch (section) {
		case 0:
			return @"Footer Sezione 1";
			break;
		case 1:
			return @"Footer Sezione 2";
			break;
		case 2:
			return @"Footer Sezione 3";
			break;
		default:
			return @"Footer Sezione x";
			break;
	}
}
 */

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    if (section == 0){
        [headerView setBackgroundColor:[UIColor purpleColor]];
        

    }
    else [headerView setBackgroundColor:[UIColor clearColor]];
     
    return headerView;

}*/


//setta il numero di righe della tabella
/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	
	//numero di righe deve corrispondere al numero di elementi della lista
	return [lista count];
}
*/


//settiamo il contenuto delle varie celle
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:@"cellID"] autorelease];
	}
	//inseriamo nella cella l'elemento della lista corrispondente
	cell.textLabel.text = [lista objectAtIndex:indexPath.row];
	
	return cell;
}*/



- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSInteger retInt = 0;
	if (!indexPath.section){
		return indexPath.row;
	}
	for (int i=0; i<indexPath.section;i++){
		retInt += [tableView numberOfRowsInSection:i];
	}
    
	return retInt + indexPath.row;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	cell.backgroundColor = (realRow%2)?[UIColor colorWithRed:1 green:.76 blue:1 alpha:1]:[UIColor colorWithRed:.9 green:.96 blue:.81 alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// static NSString *CellIdentifier = @"Cell";
    NSDictionary *dictionary = [listaOggetti objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Elementi"];
	NSDictionary *cellData = [array objectAtIndex:indexPath.row];

      
    //NSDictionary *cellData = [lista objectAtIndex:indexPath.row];
	//NSString *dataKey = [cellData objectForKey:@"id"];
	//NSString *cellType = [cellData objectForKey:@"id"];
    
	/*UITableViewCell *cell = [tableView
     dequeueReusableCellWithIdentifier:@"cellID"];
     
     if (cell == nil){
     cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cellID"] autorelease];
     //setta lo stile con cui vengono selezionate le righe
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }*/
    
	
	//CELLA CUSTOM
	TableCellView *cell = (TableCellView *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TableCellView" owner:self options:nil];
		cell = tblCell;
	}
	
	//NSUInteger row = [indexPath row];
    
    
	
	
	//[cell setImageCellWithUrl:@"http://www.lubannaiuolu.net/forum/Themes/classic/images/off.gif"];
    // [cell setImageCell:[imagesArray objectAtIndex:row]];
	//[cell setLabelText:[cellData objectForKey:@"name"]];
	
	cell.cellText.text = [cellData objectForKey:@"name"];
    
    UIImage *icon = [UIImage imageNamed:[cellData objectForKey:@"icon"]];
	[[cell imageView] setImage:icon];
	//[cell setDetailText:[NSString stringWithFormat:@"This is row: %i", row + 1]];
    
    //cell.detailText.text = [NSString stringWithFormat:@"This is row: %i", row + 1];
	cell.detailText.text = [cellData objectForKey:@"description"];
    
    cell.backgroundColor = [UIColor grayColor];
   // else cell.backgroundColor = [UIColor whiteColor];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
  
	//static NSString *CellIdentifier = @"cellID";
	
	/*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
     }*/
	
	// Configure cell
	
	//NSUInteger row = [indexPath row];
	
	// Sets the text for the cell
	//cell.textLabel.text = [cellData objectForKey:@"name"];
	
	// Sets the imageview for the cell
	//cell.imageView.image = [imagesArray objectAtIndex:row];
	
	// Sets the accessory for the cell
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// Sets the detailtext for the cell (subtitle)
	//cell.detailTextLabel.text = [NSString stringWithFormat:@"This is row: %i", row + 1];
	
    
	// Impostiamo la datakey della cella
	//cell.dataKey = dataKey;
	
	//cell.textLabel.text = [cellData objectForKey:@"name"];
	
	// Sets the imageview for the cell
	//cell.imageView.image = [imagesArray objectAtIndex:indexPath.row];
	
	// Sets the accessory for the cell
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// Sets the detailtext for the cell (subtitle)
	//cell.detailTextLabel.text = [NSString stringWithFormat:@"This is row: %i", indexPath.row + 1];
	
	// Impostiamo la datakey della cella
	//cell.dataKey = dataKey;
	
	//cell.textLabel.text = [cellData objectForKey:@"name"];
	
    
	
    return cell;
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
	
    NSDictionary *dictionary = [listaOggetti objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Elementi"];
	NSDictionary *cellData = [array objectAtIndex:indexPath.row];

  
	/*UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:@"Hai selezionato:" message:[cellData objectForKey:@"id"] delegate:self cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[popUp show];
	[popUp release];
	 */
	
	NSMutableString *idBoard = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"id"]];
	//idBoard = [cellData objectForKey:@"id"];
	
	appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.idBoard = idBoard;
    
    NSMutableString *string1 = [NSMutableString stringWithString: @"Board: "];
    appDelegate.titleCategory = (NSMutableString *)[string1 stringByAppendingString:[cellData objectForKey:@"name"]];
    
	
	viewTopics = [[TopicViewController alloc] initWithNibName:@"TopicsView" bundle:[NSBundle mainBundle]];
	    
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewTopics animated:YES];
	
	//rilasciamo il controller
	[viewTopics release];
	viewTopics = nil;
	
	
	[idBoard release];
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




- (void)dealloc {
    [viewTopics dealloc];
	[lista dealloc];
    
    [listaCategorie dealloc];
    [listaOggetti dealloc];
   
	[appDelegate dealloc];
    [spinner dealloc];
    [progressAlert dealloc];
	
	[super dealloc];
}


@end

