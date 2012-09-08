//
//  FirstViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuBannAppAppDelegate.h"
#import "FeedForumCellView.h"

@class LuBannAppAppDelegate;

@interface FeedForumViewController : UITableViewController <NSXMLParserDelegate> {
	// parser XML
	NSXMLParser *rssParser;
	// elenco degli elementi letti dal feed
	NSMutableArray *elencoFeed;
	
	//variabile temporanea pe ogni elemento
	NSMutableDictionary *item;
	
	// valori dei campi letti dal feed
	NSString *currentElement;
	NSMutableString *currentTitle, *currentDate, *currentSummary, *currentLink, *currentAuthor;
	
	LuBannAppAppDelegate *appDelegate;
	
	//controller della vista che dovrà essere aperta
	UITableViewController *viewSinglePost;
    
    IBOutlet FeedForumCellView *tblCell;
    UIActivityIndicatorView *spinner;
    UIAlertView *progressAlert;
}

@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet FeedForumCellView *tblCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert;

- (void)parseXMLFileAtURL:(NSData *) responseData;


@end