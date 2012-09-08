//
//  SinglePostViewController.h
//  LuBannApp
//
//  Created by Fr@nk on 06/03/11.
//  Copyright 2011 Eustema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuBannAppAppDelegate.h"


@interface SinglePostViewController : UIViewController<UIWebViewDelegate> {
	
	IBOutlet UIWebView *webView;
	LuBannAppAppDelegate *appDelegate;
        IBOutlet UIActivityIndicatorView *m_activity; 
}

@property (nonatomic, retain) LuBannAppAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *m_activity; 
@end
