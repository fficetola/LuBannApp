//
//  TopicViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 27/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuBannAppAppDelegate.h"
#import "TopicCellView.h"




@interface TopicViewController : UITableViewController {
	//array che conterrà gli elementi da visualizzare nella tabella
	NSMutableArray *listaTopics;
    NSMutableArray *listaDettagli;
    
	IBOutlet TopicCellView *tblCell;
    
    
	NSString *titleCategory;
	NSString *idBoard;
	
	//controller della vista che dovrà essere aperta
	UITableViewController *viewPosts;
	
	LuBannAppAppDelegate *appDelegate;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet  UIAlertView *progressAlert;
}

@property (nonatomic, retain) NSMutableArray *listaTopics;
@property (nonatomic, retain) NSMutableArray *listaDettagli;
@property (nonatomic, retain) NSString *titleCategory;
@property (nonatomic, retain) NSString *idBoard;
@property (nonatomic, retain) IBOutlet TopicCellView *tblCell;
@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert;
@end
