//
//  PostViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 01/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuBannAppAppDelegate.h"
#import "PostCellView.h"


@interface PostViewController : UITableViewController {
	
	//array che conterrà gli elementi da visualizzare nella tabella
	NSMutableArray *listaPosts;
	
	LuBannAppAppDelegate *appDelegate;
    
    IBOutlet PostCellView *tblCell;
	
	//controller della vista che dovrà essere aperta
	UITableViewController *viewSinglePost;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet  UIAlertView *progressAlert;
}

@property (nonatomic, retain) NSMutableArray *listaPosts;
@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet PostCellView *tblCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert;

@end
