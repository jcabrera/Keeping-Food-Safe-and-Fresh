//
//  Level2Controller.h
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Level2Controller : UITableViewController {
	NSMutableArray *listOfItems;
	NSArray *keys;
	NSString *selectedCategory;

}
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSString *selectedCategory;
@end
