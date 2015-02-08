//
//  RootViewController.h
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface RootViewController : UITableViewController {
	
	NSMutableArray *keys;
	NSMutableDictionary *dictionary;
}
@property (nonatomic, strong) NSMutableArray *keys; 
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end
