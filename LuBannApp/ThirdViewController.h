//
//  ThirdViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 24/02/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThirdViewController : UIViewController <UITextFieldDelegate> {
	
	//IBOutlet UIWebView *webView;
    IBOutlet UITextField *nome;
    IBOutlet UITextField *email;

    
}

-(IBAction)sendMail;

@property (nonatomic, retain) UITextField *nome;
@property (nonatomic, retain) UITextField *email;

@end
