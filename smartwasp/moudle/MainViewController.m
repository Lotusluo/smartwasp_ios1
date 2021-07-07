//
//  MainViewController.m
//  smartwasp
//
//  Created by luotao on 2021/4/20.
//

#import "MainViewController.h"
#import "IFLYOSUIColor+IFLYOSColorUtil.h"
#import "CommonTabController.h"
#import "FinderViewController.h"
#import "UserViewController.h"
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import "AppDelegate+Global.h"
#import "AppDelegate.h"
#import "JCGCDTimer.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"


#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)


@interface MainViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic) Reachability *hostReachability;

@end

@implementation MainViewController
- (instancetype)init{
    self = [super init];
    if(self){
        //tabbar标题
        NSArray *titleSources = @[NSLocalizedString(@"tab_dialog",nil),
                                  NSLocalizedString(@"tab_find",nil),
                                  NSLocalizedString(@"tab_skill",nil),
                                  NSLocalizedString(@"tab_home",nil),
                                  NSLocalizedString(@"tab_usr",nil)];
        
        NSArray *iconSources = @[@"icon_tab_dialog",
                                 @"icon_tab_find",
                                 @"icon_tab_skill",
                                 @"icon_tab_smart",
                                 @"icon_tab_mine"];
        
        NSArray *iconSelctedSources = @[@"icon_tab_dialog_selected",
                                        @"icon_tab_find_selected",
                                        @"icon_tab_skill_selected",
                                        @"icon_tab_smart_selected",
                                        @"icon_tab_mine_selected"];
      
        [self.tabBar setTintColor:  [UIColor colorWithHexString:@"#f6921e"]];
        //对话页
        CommonTabController *dialogVc = [[CommonTabController alloc] init];
        dialogVc.vcType = TALK;
        dialogVc.tag = @"TALK";
        [self addChildViewController:dialogVc];
        //发现页
        FinderViewController *finderVc = [[FinderViewController alloc] init];
        [self addChildViewController:finderVc];
        //技能页
        CommonTabController *skillVc = [[CommonTabController alloc] init];
        skillVc.vcType = SKILLS;
        skillVc.tag = @"SKILLS";
        [self addChildViewController:skillVc];
        //家居页
        CommonTabController *homeVc = [[CommonTabController alloc] init];
        homeVc.vcType =  CONTROLLED_DEVICES;
        homeVc.tag = @"CONTROLLED_DEVICES";
        [self addChildViewController:homeVc];
        //我的页
        UserViewController *userVc = [[UserViewController alloc] init];
        [self addChildViewController:userVc];

        NSEnumerator *enumerator = self.viewControllers.objectEnumerator;
        UIViewController* vc;
        int i = 0;
        while (vc = [enumerator nextObject]) {
            vc.tabBarItem.title = titleSources[i];
            vc.tabBarItem.selectedImage = [UIImage imageNamed:iconSelctedSources[i]];
            vc.tabBarItem.image = [UIImage imageNamed:iconSources[i]];
            i++;
        }
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
//    if (@available(iOS 7.0, *)) {
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
//    }
    // Do any additional setup after loading the view.
}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if ([self.navigationController.viewControllers count] == 1) {
//        return NO;
//    }else{
//        return YES;
//    }
//}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus){
        case NotReachable:{
            break;
        }
        case ReachableViaWiFi:
        case ReachableViaWWAN:{
//            @try {
//                        NSException *e = [NSException
//                                          exceptionWithName:@"FileNotFoundException"
//                                          reason:@"File Not Found on System"
//                                          userInfo:nil];
//                        @throw e;
//                    }
//                    @catch (NSException *exception) {
//                        if ([[exception name] isEqualToString:NSInvalidArgumentException]) {
//                            NSLog(@"%@", exception);
//                        } else {
//                            @throw exception;
//                        }
//                    }
//                    @finally {
//                        NSLog(@"finally");
//                    }
            if(APPDELEGATE.curDevice){
                [APPDELEGATE subscribeDeviceStatus];
                [APPDELEGATE subscribeMediaStatus];
            }
            break;
        }
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [APPDELEGATE requestBindDevices];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.hostReachability stopNotifier];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
