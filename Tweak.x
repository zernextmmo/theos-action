#import <UIKit/UIKit.h>

@interface FBToolMenu : UIView
@end

@implementation FBToolMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.layer.cornerRadius = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        label.text = @"FB TOOL ACTIVE";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}
@end

%hook FBRootViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 100, 60, 60);
        btn.backgroundColor = [UIColor blueColor];
        btn.layer.cornerRadius = 30;
        [btn setTitle:@"MENU" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showMyMenu) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
    });
}

%new
- (void)showMyMenu {
    FBToolMenu *menu = [[FBToolMenu alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
}
%end
