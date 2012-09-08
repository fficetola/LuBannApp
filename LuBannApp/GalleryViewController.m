//
//  GalleryViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 15/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "GalleryViewController.h"
#import "PhotoTest2Controller.h"
#import "UIImage+Scale.h"
#import "UIImageView+Cached.h"
#import "Utils.h"

@implementation GalleryViewController
@synthesize lista;
@synthesize listaOggetti;
@synthesize listaCategorie;
@synthesize appDelegate;

@synthesize tblCell;

@synthesize spinner;
@synthesize progressAlert;


#pragma mark -
#pragma mark View lifecycle





- (void) caricaListaGallery{
   
    //carico le categorie
    NSString *indirizzoCategorie = @"http://www.lubannaiuolu.net/lubannapp/getCategoriesGallery.php";
    
    listaCategorie = [[NSMutableArray alloc] initWithArray:[Utils downloadPlist:indirizzoCategorie]];
    
    
    // NSURL *urlCategorie = [NSURL URLWithString:indirizzoCategorie];
    // listaCategorie = [[NSMutableArray alloc]init];
    
    listaOggetti = [[NSMutableArray alloc] init];
    
    
    //scorro la lista delle categorie e recupero le board per ciascuna di esse
    for (int i=0; i<[listaCategorie count]; i++){
        
        NSDictionary *dictionaryCategoryTemp = [listaCategorie objectAtIndex:i];
        NSString *idCategory = [dictionaryCategoryTemp objectForKey:@"id"];
        
        
        //recupero la lista delle board per la categoria corrente
        //NSString *plisStructure = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
        NSString *indirizzoBoard = @"http://www.lubannaiuolu.net/lubannapp/getSectionsGallery.php?idCategory=";
        indirizzoBoard = [indirizzoBoard stringByAppendingString:idCategory];
        //crea un oggetto URL
        //NSURL *urlBoard = [NSURL URLWithString:indirizzoBoard];
        
        lista = [[NSMutableArray alloc]initWithArray:[Utils downloadPlist:indirizzoBoard]];
        
        //lista = [[NSMutableArray alloc]initWithContentsOfFile:plisStructure];
        NSDictionary *dictBoard = [NSDictionary dictionaryWithObject:lista forKey:@"Elementi"];
               
        [listaOggetti addObject:dictBoard];
        self.navigationItem.title = @"Gallery";    
        
        //[dictBoard release];
     
        
    }  
    
    /* reload the table */
    //[self.tableView reloadData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [spinner stopAnimating];
    [progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
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
    [self performSelectorOnMainThread:@selector(caricaListaGallery) withObject:nil waitUntilDone:NO];
    [pool drain];
    
    //[self caricaListaGallery];
    
    //SECONDA ALTERNATIVA
    /*NSOperationQueue *queue = [NSOperationQueue new];
    
   
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(caricaListaGallery)
                                                                              object:nil];
    [queue addOperation:operation];
    [operation release];*/
     
     
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}*/

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
  //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
   
/*          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
        [self performSelectorOnMainThread:@selector(caricaListaGallery) withObject:nil waitUntilDone:TRUE];    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
 */              

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
	GalleryCellView *cell = (GalleryCellView *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"GalleryCellView" owner:self options:nil];
		cell = tblCell;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	//NSUInteger row = [indexPath row];

	
	// Impostiamo la datakey della cella
	//cell.dataKey = dataKey;
	cell.cellText.text = [cellData objectForKey:@"name"];
    cell.detailText.text = [cellData objectForKey:@"count"];
    cell.lastUpdateText.text = [cellData objectForKey:@"lastPhoto"];
    
   // UIImage *icon = [UIImage imageWithContentsOfFile:[cellData objectForKey:@"icon"]];
    NSURL *url = [NSURL URLWithString:[cellData objectForKey:@"icon"]];
   // NSData *imageData = [NSData dataWithContentsOfURL:url];
   // UIImage *icon = [[UIImage alloc] initWithData:imageData];
    
    //[[cell imageView] setImage:icon];  
      
    // Scale the image
   // UIImage *scaledImage = [icon scaleToSize:CGSizeMake(40.0f, 40.0f)];
    //cell.imageCell.image = scaledImage;
    
    //Buffering e cache le immagini (UIImageView+Cached.h)
    //cell.imageCell.layer.masksToBounds = YES;
    //cell.imageCell.layer.cornerRadius = 0;
   
    [cell.imageCell loadFromURL:url];
    //float sw=42/cell.imageView.image.size.width;
    //float sh=42/cell.imageView.image.size.height;
    //cell.imageCell.transform=CGAffineTransformMakeScale(sw,sh);

    

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
	
	NSMutableString *idSection = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"id"]];
	NSMutableString *nameSection = [[NSMutableString alloc] initWithString:[cellData objectForKey:@"name"]];
	
	
	appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.idSection = idSection;
	
	viewPhotos = [[PhotoTest2Controller alloc] init];
	//viewPhotos.idSection = idSection;
	viewPhotos.nameSection = nameSection;
	
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewPhotos animated:YES];
	
	//rilasciamo il controller
	[viewPhotos release];
	 viewPhotos = nil;
	
	/*UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:@"Hai selezionato:" message:[cellData objectForKey:@"id"] delegate:self cancelButtonTitle:@"OK"
	 otherButtonTitles:nil];
	 [popUp show];
	 [popUp release];
	 */
	
	[idSection release];
	[nameSection release];
    //[dictionary release];
    //[cellData release];
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
	[viewPhotos release];
    [listaCategorie dealloc];
    [listaOggetti dealloc];
    [spinner dealloc];
    [super dealloc];

}


@end

