//
//  GalleryViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 15/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePostViewController.h"
#import "LuBannAppAppDelegate.h"
#import "NumeriCellView.h"


@interface NumeriViewController : UITableViewController<UIWebViewDelegate> {
	//array che conterrà gli elementi da visualizzare nella tabella
	NSArray *lista;
	
	LuBannAppAppDelegate *appDelegate;
    
    //controller della vista che dovrà essere aperta
	UITableViewController *viewSingleNumero;
    
    NSMutableArray *listaCategorie;
    NSMutableArray *listaOggetti;
    
    NSMutableString *path;
    
    IBOutlet NumeriCellView *tblCell;
    UIActivityIndicatorView *spinner;
    UIAlertView *progressAlert;
    

}


@property (nonatomic, retain) NSArray *lista;
@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) NSMutableArray *listaCategorie;
@property (nonatomic, retain) NSMutableArray *listaOggetti;

@property (nonatomic, retain) IBOutlet NumeriCellView *tblCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert; 

@end
