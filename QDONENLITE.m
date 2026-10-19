#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface QDONPanel : UIView
@end

@implementation QDONPanel

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:0.035 green:0.035 blue:0.085 alpha:0.97];
        self.layer.cornerRadius = 16;
        self.layer.borderWidth = 1.2;
        self.layer.borderColor = [UIColor colorWithRed:0.55 green:0.22 blue:1 alpha:1].CGColor;
        self.layer.shadowColor = [UIColor purpleColor].CGColor;
        self.layer.shadowOpacity = 0.35;
        self.layer.shadowRadius = 16;
        self.clipsToBounds = NO;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, frame.size.width - 52, 30)];
        title.text = @"♛ QDON ENLITE";
        title.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBlack];
        title.textColor = [UIColor colorWithRed:0.76 green:0.49 blue:1 alpha:1];
        [self addSubview:title];

        UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
        close.frame = CGRectMake(frame.size.width - 38, 8, 28, 28);
        [close setTitle:@"×" forState:UIControlStateNormal];
        close.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [close setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 46, frame.size.width - 24, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.36 green:0.18 blue:0.68 alpha:1];
        [self addSubview:line];

        NSArray *items = @[
            @[@"COMBAT", @"Damage +20% (UI demo)"],
            @[@"MOVEMENT", @"Speed x1–x5 (UI demo)"],
            @[@"MOVEMENT", @"Fly Mode (UI demo)"],
            @[@"WORLD", @"Teleport (UI demo)"],
            @[@"WORLD", @"Diamond Ore Vision (UI demo)"],
            @[@"SKIN", @"Skin settings (UI demo)"]
        ];

        CGFloat y = 56;
        for (NSArray *item in items) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, y, frame.size.width - 80, 36)];
            label.numberOfLines = 2;
            label.text = [NSString stringWithFormat:@"%@\n%@", item[0], item[1]];
            label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
            label.textColor = UIColor.whiteColor;
            [self addSubview:label];

            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
            sw.transform = CGAffineTransformMakeScale(0.72, 0.72);
            sw.onTintColor = [UIColor colorWithRed:0.53 green:0.2 blue:1 alpha:1];
            sw.center = CGPointMake(frame.size.width - 32, y + 18);
            [sw addTarget:self action:@selector(demoToggle:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:sw];

            y += 43;
        }

        UILabel *contact = [[UILabel alloc] initWithFrame:CGRectMake(14, y + 2, frame.size.width - 28, 46)];
        contact.numberOfLines = 3;
        contact.font = [UIFont systemFontOfSize:10];
        contact.textColor = [UIColor colorWithRed:0.77 green:0.73 blue:0.9 alpha:1];
        contact.text = @"Telegram: t.me/ontopvipsql\nAdmin: thelightasean\nTikTok: @qdonenlitegame";
        [self addSubview:contact];
    }
    return self;
}

- (void)closePanel {
    self.hidden = YES;
}

- (void)demoToggle:(UISwitch *)sender {
    // UI-only prototype — không thay đổi gameplay Minecraft
    NSLog(@"QDON ENLITE UI demo toggle: %@", sender.on ? @"ON" : @"OFF");
}

@end

@interface QDONOverlayController : UIViewController
@property (nonatomic, strong) QDONPanel *panel;
@property (nonatomic, strong) UIButton *reopenButton;
@end

@implementation QDONOverlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    self.view.userInteractionEnabled = YES;

    CGFloat width = MIN(UIScreen.mainScreen.bounds.size.width - 24, 340);
    CGFloat height = 390;
    self.panel = [[QDONPanel alloc] initWithFrame:CGRectMake(12, 90, width, height)];
    [self.view addSubview:self.panel];

    // Nút mở lại panel khi đã đóng
    self.reopenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.reopenButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 70, 120, 54, 54);
    self.reopenButton.backgroundColor = [UIColor colorWithRed:0.45 green:0.15 blue:0.9 alpha:0.85];
    self.reopenButton.layer.cornerRadius = 27;
    [self.reopenButton setTitle:@"♛" forState:UIControlStateNormal];
    self.reopenButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    [self.reopenButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.reopenButton addTarget:self action:@selector(showPanel) forControlEvents:UIControlEventTouchUpInside];
    self.reopenButton.hidden = YES;
    [self.view addSubview:self.reopenButton];
}

- (void)showPanel {
    self.panel.hidden = NO;
    self.reopenButton.hidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Theo dõi khi panel bị ẩn để hiện nút reopen
    if (self.panel.hidden) {
        self.reopenButton.hidden = NO;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

static UIWindow *qdonWindow;

__attribute__((constructor))
static void QDONENLITEStart(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                          object:nil
                                                           queue:NSOperationQueue.mainQueue
                                                      usingBlock:^(__unused NSNotification *note) {
            if (qdonWindow) return;

            UIWindowScene *scene = nil;
            for (UIScene *s in UIApplication.sharedApplication.connectedScenes) {
                if ([s isKindOfClass:UIWindowScene.class]) {
                    scene = (UIWindowScene *)s;
                    break;
                }
            }
            if (!scene) return;

            qdonWindow = [[UIWindow alloc] initWithWindowScene:scene];
            qdonWindow.frame = UIScreen.mainScreen.bounds;
            qdonWindow.windowLevel = UIWindowLevelAlert - 1;
            qdonWindow.backgroundColor = UIColor.clearColor;
            qdonWindow.rootViewController = [QDONOverlayController new];
            qdonWindow.hidden = NO;
        }];

        if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
        }
    });
}
