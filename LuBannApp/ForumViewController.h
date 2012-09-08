//
//  ForumViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 26/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuBannAppAppDelegate.h"
#import "TableCellView.h"

@class LuBannAppAppDelegate;

@interface ForumViewController : UITableViewController {
	//array che conterrà gli elementi da visualizzare nella tabella
	NSArray *lista;
    
    NSMutableArray *listaCategorie;
    NSMutableArray *listaOggetti;
	
	//controller della vista che dovrà essere aperta
	UITableViewController *viewTopics;
	
	IBOutlet TableCellView *tblCell;
	
	LuBannAppAppDelegate *appDelegate;
    UIActivityIndicatorView *spinner;
    UIAlertView *progressAlert;
}


@property (nonatomic, retain) NSArray *lista;

@property (nonatomic, retain) NSMutableArray *listaCategorie;
@property (nonatomic, retain) NSMutableArray *listaOggetti;


@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet TableCellView *tblCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert; 


@end