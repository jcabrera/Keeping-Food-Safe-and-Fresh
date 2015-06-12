//
//  Keeping_Food_Safe_and_FreshAppDelegate.h
//  Keeping Food Safe and Fresh
//
//  Created by JENNIFER CRAWFORD on 7/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Keeping_Food_Safe_and_FreshAppDelegate : NSObject <UIApplicationDelegate> /*{
    
    UIWindow *window;
    UINavigationController *navigationController;
}*/
@property (strong, nonatomic) UIWindow *window;
+(sqlite3 *) getNewDBConnection;
/*@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;*/

@end

