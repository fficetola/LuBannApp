//
//  SinglePostViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 06/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "SinglePostViewController.h"
#import "LuBannAppAppDelegate.h"

@implementation SinglePostViewController

@synthesize appDelegate;
@synthesize m_activity;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad{
    
    CGRect frame = self.view.bounds;
    frame.origin.y = -frame.size.height;
    UIView* hiddenView = [[UIView alloc] initWithFrame:frame];
    hiddenView.autoresizingMask = (
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin
                                   );
    
    hiddenView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"bannabackground.png"]];
    [self.view addSubview:hiddenView];
    [hiddenView release];
    
    m_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [m_activity setHidesWhenStopped:YES]; 
    
    [self.view addSubview:m_activity];
    m_activity.center = self.view.center;

    
	appDelegate = (LuBannAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//indirizzo web da caricare
	NSString *indirizzo = @"http://www.lubannaiuolu.net/lubannapp/getSinglePost.php?id_msg=";
	indirizzo = [indirizzo stringByAppendingString:appDelegate.idPost];
    
    webView.delegate = self;
    
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[webView loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [m_activity startAnimating];
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [m_activity stopAnimating];
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)myWebView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>", @"Errore nel caricamento della pagina!"];
    //error.localizedDescription];
	[webView loadHTMLString:errorString baseURL:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [webView release];
	[super dealloc];
}


@end
