#import <UIKit/UIKit.h>

// --- Giao diện Menu của Tool ---
@interface FBToolMenu : UIView
@property (nonatomic, strong) UITextField *uidField;
@property (nonatomic, strong) UITextField *captionField;
@property (nonatomic, strong) UITextField *photoPathField;
@property (nonatomic, strong) UITextField *delayField;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation FBToolMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor systemBlueColor].CGColor;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 260, 30)];
        title.text = @"FB AUTO TOOL BY ZERNEXT";
        title.textColor = [UIColor systemBlueColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];

        // Ô nhập UID Group
        self.uidField = [[UITextField alloc] initWithFrame:CGRectMake(15, 50, 230, 35)];
        self.uidField.placeholder = @" Nhập UID Group...";
        self.uidField.backgroundColor = [UIColor whiteColor];
        self.uidField.layer.cornerRadius = 5;
        [self addSubview:self.uidField];

        // Ô nhập Caption (Nội dung bài viết)
        self.captionField = [[UITextField alloc] initWithFrame:CGRectMake(15, 95, 230, 35)];
        self.captionField.placeholder = @" Nội dung bài viết...";
        self.captionField.backgroundColor = [UIColor whiteColor];
        self.captionField.layer.cornerRadius = 5;
        [self addSubview:self.captionField];

        // Ô nhập đường dẫn ảnh (Link ảnh trong máy)
        self.photoPathField = [[UITextField alloc] initWithFrame:CGRectMake(15, 140, 230, 35)];
        self.photoPathField.placeholder = @" Đường dẫn ảnh (nếu có)...";
        self.photoPathField.backgroundColor = [UIColor whiteColor];
        self.photoPathField.layer.cornerRadius = 5;
        [self addSubview:self.photoPathField];

        // Ô nhập thời gian Delay
        self.delayField = [[UITextField alloc] initWithFrame:CGRectMake(15, 185, 230, 35)];
        self.delayField.placeholder = @" Delay (giây)...";
        self.delayField.backgroundColor = [UIColor whiteColor];
        self.delayField.keyboardType = UIKeyboardTypeNumberPad;
        self.delayField.layer.cornerRadius = 5;
        [self addSubview:self.delayField];

        // Nút Bắt đầu (Auto Post)
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [startBtn setTitle:@"BẮT ĐẦU AUTO POST" forState:UIControlStateNormal];
        startBtn.frame = CGRectMake(15, 235, 230, 40);
        startBtn.backgroundColor = [UIColor systemBlueColor];
        [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        startBtn.layer.cornerRadius = 10;
        [startBtn addTarget:self action:@selector(handleAutoPost) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];

        // Trạng thái thông báo
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 285, 260, 20)];
        self.statusLabel.text = @"Trạng thái: Đang chờ...";
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];

        // Nút Đóng Menu
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setTitle:@"ĐÓNG MENU" forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(15, 315, 230, 30);
        [closeBtn setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)handleAutoPost {
    self.statusLabel.text = @"Đang xử lý...";
    self.statusLabel.textColor = [UIColor systemYellowColor];
    
    int delayTime = [self.delayField.text intValue];
    if (delayTime <= 0) delayTime = 3;

    // Giả lập logic đăng bài theo delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"TRẠNG THÁI: DONE!";
        self.statusLabel.textColor = [UIColor systemGreenColor];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"THÔNG BÁO" 
                                    message:@"Đã hoàn thành tác vụ up bài!" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

- (void)closeMenu {
    [self removeFromSuperview];
}

@end

// --- Hook vào giao diện chính của Facebook ---
%hook FBRootViewController 

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    // Tạo nút Logo lơ lửng bên góc trái để mở Menu
    static UIButton *floatingBtn = nil;
    if (!floatingBtn) {
        floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingBtn.frame = CGRectMake(10, 150, 50, 50);
        floatingBtn.backgroundColor = [UIColor systemBlueColor];
        floatingBtn.layer.cornerRadius = 25;
        [floatingBtn setTitle:@"TOOL" forState:UIControlStateNormal];
        floatingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        floatingBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        floatingBtn.layer.shadowOpacity = 0.8;
        floatingBtn.layer.shadowOffset = CGSizeMake(0, 2);
        
        [floatingBtn addTarget:self action:@selector(openToolMenu) forControlEvents:UIControlEventTouchUpInside];
        
        // Cho phép kéo thả nút (Pan Gesture)
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [floatingBtn addGestureRecognizer:pan];
        
        [[UIApplication sharedApplication].keyWindow addSubview:floatingBtn];
    }
}

%new
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *btn = sender.view;
    CGPoint translation = [sender translationInView:btn.superview];
    btn.center = CGPointMake(btn.center.x + translation.x, btn.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:btn.superview];
}

%new
- (void)openToolMenu {
    FBToolMenu *menu = [[FBToolMenu alloc] initWithFrame:CGRectMake(50, 150, 260, 360)];
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
}

%end
