//
//  MusicPlayViewController.m
//  smartwasp
//
//  Created by luotao on 2021/6/16.
//

#import "MusicPlayViewController.h"
#import "AppDelegate.h"
#import "UILabel+Extension.h"
#import "UIImage+Extension.h"
#import "DeviceBean.h"
#import "IFLYOSUIColor+IFLYOSColorUtil.h"
#import "NormalToolbar.h"
#import "UIImageView+WebCache.h"
#import "IFLYOSSDK.h"


#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface MusicPlayViewController ()

@property (weak, nonatomic) IBOutlet NormalToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *playView;

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateToolbarUI:APPDELEGATE.curDevice];
    [self mediaSetCallback:APPDELEGATE.mediaStatus.data];
   
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.container.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.container.bounds cornerRadius:100.0].CGPath;

}


//更新toobarUI
-(void)updateToolbarUI:(DeviceBean*)device{
    UIImage *image =[UIImage imageNamed:@"icon_status"];
    UIColor *color = [UIColor colorWithHexString:device.isOnLine ?  @"#03F484":@"#B8B8B8"];
    UILabel *titleView = self.toolBar.txtView;
    titleView.text = device.name;
    [titleView setLeftSquareDrawable:[image renderImageWithColor:color]];
}


- (IBAction)onPlayOrPause:(id)sender {
    if(self.playView.selected){
        //暂停
        [[IFLYOSSDK shareInstance] musicControlStop:APPDELEGATE.curDevice.device_id statusCode:^(NSInteger code) {
        } requestSuccess:^(id _Nonnull data) {
        } requestFail:^(id _Nonnull data) {
        }];
    }else{
        //恢复
        [[IFLYOSSDK shareInstance] musicControlResume:APPDELEGATE.curDevice.device_id statusCode:^(NSInteger code) {
        } requestSuccess:^(id _Nonnull data) {
        } requestFail:^(id _Nonnull data) {
        }];
    }
}

//上一首
- (IBAction)onForward:(id)sender {
    [[IFLYOSSDK shareInstance] musicControlPrevious:APPDELEGATE.curDevice.device_id statusCode:^(NSInteger code) {
    } requestSuccess:^(id _Nonnull data) {
    } requestFail:^(id _Nonnull data) {
    }];
}

//下一首
- (IBAction)onBackward:(id)sender {
    [[IFLYOSSDK shareInstance] musicControlNext:APPDELEGATE.curDevice.device_id statusCode:^(NSInteger code) {
    } requestSuccess:^(id _Nonnull data) {
    } requestFail:^(id _Nonnull data) {
    }];
}

//音量调节
- (IBAction)voiceChangedClick:(id)sender {
    [[IFLYOSSDK shareInstance] musicControlVolume:APPDELEGATE.curDevice.device_id volume:self.sliderView.value statusCode:^(NSInteger code) {
    } requestSuccess:^(id _Nonnull data) {
    } requestFail:^(id _Nonnull data) {
    }];
}

//处理设备媒体状态通知
-(void)mediaSetCallback:(MusicStateBean* __nullable) musicStateBean{
    if(musicStateBean){
        self.sliderView.value = musicStateBean.speaker.volume;
        self.playView.selected = musicStateBean.isPlaying;
        self.titleView.text = musicStateBean.music.name;
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:musicStateBean.music.image]];
    }
}

//设备在线状态变更
-(void)onLineChangedCallback{
    [self updateToolbarUI:APPDELEGATE.curDevice];
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
