//
//  DetailViewController.h
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSString *selectedCategory;
	NSString *selectedProduce;


	
}

@property (nonatomic, strong) NSString *selectedProduce;
@property (nonatomic, strong) NSString *selectedCategory;

@end


	

