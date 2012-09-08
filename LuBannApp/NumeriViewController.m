//
//  GalleryViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 15/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "NumeriViewController.h"
#import "SingleNumeroViewController.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"

@implementation NumeriViewController
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
	
	//NSString *plisStructure = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
	//NSString *indirizzo = @"http://www.lubannaiuolu.net/lubannapp/getSectionsGallery.php";
	//crea un oggetto URL
	//NSURL *url = [NSURL URLWithString:indirizzo];
	
	
	//lista = [[NSMutableArray alloc]initWithContentsOfURL:url];

    
	
}*/



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
    
    //carico le categorie
    NSString *indirizzoCategorie = @"http://www.lubannaiuolu.net/lubannapp/getGiornalinoBannaAnni.php";
    NSURL *url = [NSURL URLWithString:indirizzoCategorie];
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
        listaCategorie = [[NSMutableArray alloc] initWithCapacity:0];
        listaOggetti = [[NSMutableArray alloc] initWithCapacity:0];
        
    } 
    else{
        //carico le categorie
        listaCategorie = [[NSMutableArray alloc] initWithArray:[Utils readPlist:responseData]];     
    

        listaOggetti = [[NSMutableArray alloc] init];
    
    
        //scorro la lista delle categorie e recupero le board per ciascuna di esse
        for (int i=0; i<[listaCategorie count]; i++){
        
            NSDictionary *dictionaryCategoryTemp = [listaCategorie objectAtIndex:i];
            NSString *idCategory = [dictionaryCategoryTemp objectForKey:@"id"];
        
        
            //recupero la lista delle board per la categoria corrente
            //NSString *plisStructure = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
            NSString *indirizzoNumeri = @"http://www.lubannaiuolu.net/lubannapp/getGiornalinoBannaNumeri.php?id=";
            indirizzoNumeri = [indirizzoNumeri stringByAppendingString:idCategory];
            //crea un oggetto URL
            //NSURL *urlBoard = [NSURL URLWithString:indirizzoNumeri];
        
            lista = [[NSMutableArray alloc]initWithArray:[Utils downloadPlist:indirizzoNumeri]];
                 
            //lista = [[NSMutableArray alloc]initWithContentsOfFile:plisStructure];
            NSDictionary *dictBoard = [NSDictionary dictionaryWithObject:lista forKey:@"Elementi"];
        
            [listaOggetti addObject:dictBoard];
        
        }
    }
	
    //[super viewDidLoad];
    
    self.navigationItem.title = @"Numeri Giornalino";
    
    /* reload the table */
    //[self.tableView reloadData];
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

-(void) awakeFromNib{
    
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
    
    //chiamo solo una volta il metodo
    if(listaOggetti==nil || [listaOggetti count]==0)[self loadData];
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
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */





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


/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
    }
    else [cell setBackgroundColor:[UIColor clearColor]];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictionary = [listaOggetti objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Elementi"];
	NSDictionary *cellData = [array objectAtIndex:indexPath.row];
    
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
	NumeriCellView *cell = (NumeriCellView *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"NumeriCellView" owner:self options:nil];
		cell = tblCell;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
	//NSUInteger row = [indexPath row];
    
	
	// Impostiamo la datakey della cella
	//cell.dataKey = dataKey;
	cell.cellText.text = [cellData objectForKey:@"name"];
    cell.detailText.text = [cellData objectForKey:@"tags"];
    
    
    UIImage *icon = nil;
    //if(indexPath.row%2 == 0){
        icon = [UIImage imageNamed:@"banna_numeri01.png"];  
    /*}
    else {
        icon = [UIImage imageNamed:@"banna_numeri02.png"];  
    }*/
    
    
    
	[[cell imageView] setImage:icon];
    
    /*
    //cell.detailText.text = [cellData objectForKey:@"count"];
    //cell.lastUpdateText.text = [cellData objectForKey:@"lastPhoto"];
    
    // UIImage *icon = [UIImage imageWithContentsOfFile:[cellData objectForKey:@"icon"]];
    /NSURL *url = [NSURL URLWithString:[cellData objectForKey:@"icon"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *icon = [[UIImage alloc] initWithData:imageData];
    
    
    //[[cell imageView] setImage:icon];  
    // Create an image
    
    // Scale the image
    UIImage *scaledImage = [icon scaleToSize:CGSizeMake(40.0f, 40.0f)];
    
	[[cell imageView] setImage:scaledImage];
    */
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
	
	NSMutableString *pathNumero = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"path"]];
    
   	viewSingleNumero = [[SingleNumeroViewController alloc] initWithNibName:@"SingleNumeroView" bundle:[NSBundle mainBundle]];
	
    appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.path = pathNumero;
    
    NSMutableString *title = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"name"]];
    appDelegate.title  = title;
    
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewSingleNumero animated:YES];
	
	//rilasciamo il controller
    [viewSingleNumero release];
	 viewSingleNumero = nil;
    
    [title release];

    [pathNumero release];
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

/*- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSError* error = nil;
    NSString * test = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.lubannaiuolu.net"] encoding:NSUnicodeStringEncoding error:&error]; 
    if (test == nil) { 
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Errore di rete" message: @"Non sei collegato ad Internet!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        [someError release]; 
    } 
}*/


- (void)dealloc {
    
    [super dealloc];
    [listaCategorie dealloc];
    [listaOggetti dealloc];
    
    [spinner dealloc];
    [progressAlert dealloc];
    
}


@end

