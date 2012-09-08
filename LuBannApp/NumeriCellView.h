//
//  TableCellView.h
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumeriCellView : UITableViewCell {
	IBOutlet UILabel *cellText;
    IBOutlet UILabel *detailText;
    IBOutlet UILabel *lastUpdateText;
	//IBOutlet UIImageView *imageCell; 
}

/*- (void)setDetailText:(NSString *)_text;
 - (void)setLabelText:(NSString *)_text;
 - (void)setImageCellWithUrl:(NSString *)_url;
 - (void)setImageCell:(UIImage *)_image;
 - (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;*/

@property (nonatomic, retain) IBOutlet UILabel *cellText;
@property (nonatomic, retain) IBOutlet UILabel *detailText;
@property (nonatomic, retain) IBOutlet UILabel *lastUpdateText;
//@property (nonatomic, retain) IBOutlet UIImageView *imageCell;


@end
