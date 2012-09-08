//
//  TableCellView.m
//  SimpleTable
//
//  Created by Adeem on 30/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FeedForumCellView.h"


@implementation FeedForumCellView

@synthesize cellText;
@synthesize detailText;
@synthesize lastUpdateText;
//@synthesize imageCell;


/*- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
 if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
 // Initialization code
 }
 return self;
 }*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


/*
 
 - (void)setLabelText:(NSString *)_text {
 cellText.text = _text;
 }
 
 - (void)setDetailText:(NSString *)_text {
 detailText.text = _text;
 }
 
 - (void)setImageCellWithUrl:(NSString *)_url {
 NSString* imageURL = @"http://www.lubannaiuolu.net/forum/Themes/classic/images/off.gif";
 NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
 
 UIImage* image1 = [[UIImage alloc] initWithData:imageData];
 self.image = [self scale:image1 toSize:CGSizeMake(30, 30)];
 
 
 //[image setImage:[self scale:image1 toSize:CGSizeMake(60, 60)]];
 [imageData release];
 [image1 release];
 }
 
 
 
 - (void)setImageCell:(UIImage *)_image {
 
 
 self.image = _image;
 
 //[image setImage:[self scale:image1 toSize:CGSizeMake(60, 60)]];
 [_image release];
 }
 
 
 - (UIImage *)scale:(UIImage *)image toSize:(CGSize)size{
 UIGraphicsBeginImageContext(size);
 [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
 UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return scaledImage;
 }
 */

- (void)dealloc {
	//[cellText dealloc];
	//[detailText dealloc];
	//[lastUpdateText dealloc];
    [super dealloc];
}

@end
