//
//  GalleryViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 15/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTest2Controller.h"
#import "LuBannAppAppDelegate.h"
#import "GalleryCellView.h"


@interface GalleryViewController : UITableViewController {
	//array che conterrà gli elementi da visualizzare nella tabella
	NSArray *lista;
	//controller della vista che dovrà essere aperta
	PhotoTest2Controller *viewPhotos;
	
	LuBannAppAppDelegate *appDelegate;
    
    NSMutableArray *listaCategorie;
    NSMutableArray *listaOggetti;
    
    
    IBOutlet GalleryCellView *tblCell;
    UIActivityIndicatorView *spinner;
    UIAlertView *progressAlert;
   
}
@property (nonatomic, retain) NSArray *lista;
@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) NSMutableArray *listaCategorie;
@property (nonatomic, retain) NSMutableArray *listaOggetti;


@property (nonatomic, retain) IBOutlet GalleryCellView *tblCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet  UIAlertView *progressAlert; 

@end
