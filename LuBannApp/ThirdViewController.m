//
//  ThirdViewController.m
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import "ThirdViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThirdViewController

@synthesize nome, email;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


/*
- (void)viewDidAppear:(BOOL)animated {    
    NSString *theMessage = @"Copyright © 2007-2011 - LuBannaiuolu.net";
    messageSize = [theMessage sizeWithFont:[UIFont systemFontOfSize:14.0]];
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageSize.width, 19)]; //x,y,width,height
    [messageView setClipsToBounds:YES]; // With This you prevent the animation to be drawn outside the bounds.
    [self.view addSubview:messageView];
    lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, messageSize.width, 19)]; //x,y,width,height
    [lblTime setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
    lblTime.font = [UIFont systemFontOfSize:14];
    [lblTime setText:theMessage];
    [lblTime setTextAlignment:UITextAlignmentLeft];
    lblTime.frame = CGRectMake(0, 0, messageSize.width, 19); //x,y,width,height
    [messageView addSubview:lblTime];
    float duration = messageSize.width / 60; // This determines the speed of the moving text.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:messageView cache:YES];
    lblTime.frame = CGRectMake(-messageSize.width, 0, messageSize.width, 19); //x,y,width,height
    [UIView commitAnimations];
   
}

*/



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
     return YES;
}

//chiude la finestra della tastiera se clicco in un'area vuota
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.email resignFirstResponder];
    }
    //See if touch was inside the label
   /* if (CGRectContainsPoint(UrlLabel.frame, [[[event allTouches] anyObject] locationInView:mainView]))
    {
        //Open webpage
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
    }*/
}


- (void)viewDidLoad{
    
}


-(IBAction)sendMail{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:@"http://www.lubannaiuolu.net/lubannapp/sendMail.php"];

    if([Utils NSStringIsValidEmail:email.text]==true){
    
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:email.text forKey:@"message"];
   
            [request setDelegate:self];
            [request startAsynchronous];
        
            [email resignFirstResponder];
           

        
    } else {
            //mando un messaggio all'utente
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Errore nei dati" message: @"Inserire una email valida!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
             email.text = @"";
    }

    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
    //mando un messaggio all'utente
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Richiesta inviata con successo" message: @"Riceverai info all'indirizzo email specificato!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    
    [email resignFirstResponder];
     email.text = @"";

    
}


- (void)requestFailed:(ASIHTTPRequest *)request

{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *error = [request error];
    if (error != nil) { 
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Errore di rete" message: @"Connettività ad Internet limitata o assente!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        [someError release];  
        
    }  
    [email resignFirstResponder];
     email.text = @"";

}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.view;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}


// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
*/


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
    //[webView release];
    [nome dealloc];
    [email dealloc];
    [super dealloc];
}


@end
