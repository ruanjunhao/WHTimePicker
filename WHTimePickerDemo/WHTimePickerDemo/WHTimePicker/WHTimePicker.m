//
//  WHTimePicker.m
//  WHTimePicker
//
//  Created by 吴浩 on 2017/6/9.
//  Copyright © 2017年 remember17. All rights reserved.
//


#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// 缩放比
#define KSCALE ([UIScreen mainScreen].bounds.size.width) / 375
#define hScale ([UIScreen mainScreen].bounds.size.height) / 500
//字体大小
#define KFONT 15

#import "WHTimePicker.h"

@interface WHTimePicker() <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *OKBtn;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UIPickerView *pickerV;
@property (nonatomic,strong)UIView *pickerBackView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, strong) NSArray *customArr;
@property(nonatomic,strong)NSMutableArray *dateArray;

@end

@implementation WHTimePicker {
    NSMutableArray *_dayArray;
    
    NSInteger _currentDay;
    NSInteger _currentMonth;
    NSInteger _currentYear;
    NSInteger _currentMonthDays;
}

+(WHTimePicker *)timePickerWithType:(ARRAYTYPE)type Frame:(CGRect)frame {
    WHTimePicker *timePicker = [[WHTimePicker alloc] initWithFrame:frame];
    timePicker.arrayType = type;
    return timePicker;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupInit];
        [self setupUI];
    }
    return self;
}

- (void)setupInit {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    _currentYear = [[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]] integerValue];
    [formatter setDateFormat:@"MM"];
    _currentMonth = [[NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]] integerValue];
    [formatter setDateFormat:@"dd"];
    _currentDay = [[NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]] integerValue];
    _currentMonthDays=[self DaysfromYear:_currentYear andMonth:_currentMonth];
    self.array = [NSMutableArray array];
}

- (void)setupUI{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = RGBA(51, 51, 51, 0.8);
    
    self.pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260*hScale)];
    self.pickerBackView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.pickerBackView];
    [self showTimerPicker];
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 53)];
    topView.backgroundColor=[UIColor colorWithHexString:@"#7aC4Eb"];
    [self.pickerBackView addSubview:topView];
    self.topView=topView;
    
    self.cancelBtn = [UIButton wh_buttonWithTitle:NSLocalizedString(@"取消", nil) backColor:nil backImageName:nil titleColor:[UIColor whiteColor] fontSize:KFONT frame:CGRectZero cornerRadius:0];
    [self.pickerBackView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(54);
    }];
    
    self.OKBtn = [UIButton wh_buttonWithTitle:NSLocalizedString(@"确定", nil) backColor:nil backImageName:nil titleColor:[UIColor whiteColor] fontSize:KFONT frame:CGRectZero cornerRadius:0];
    [self.pickerBackView addSubview:self.OKBtn];
    [self.OKBtn addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(54);
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.textColor=[UIColor whiteColor];
    [self.pickerBackView addSubview:self.typeLabel];
    self.typeLabel.font = [UIFont systemFontOfSize:KFONT];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.pickerBackView.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.OKBtn.mas_centerY).offset(0);
    }];
    
    UIView *line = [[UIView alloc]init];
    [self.pickerBackView addSubview:line];
    line.backgroundColor = RGBA(224, 224, 224, 1);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0);
    }];
    
    self.pickerV = [[UIPickerView alloc]init];
    self.pickerV.backgroundColor=[UIColor colorWithHexString:@"#f8f8f8" alpha:1.0];
    [self.pickerBackView addSubview:self.pickerV];
    self.pickerV.delegate = self;
    self.pickerV.dataSource = self;
    [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIView *tapView = [UIView new];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.pickerBackView.frame.size.height);
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemoveView)];
    [tapView addGestureRecognizer:tap];
}

- (void)tapRemoveView {
    [self removeTimerPicker];
}

- (void)setCustomArr:(NSArray *)customArr{
    _customArr = customArr;
    [self.array addObject:customArr];
}

- (void)setArrayType:(ARRAYTYPE)arrayType
{
    _arrayType = arrayType;
    switch (arrayType) {
        case GenderArray:
            self.typeLabel.text = NSLocalizedString(@"性别", nil);
            [self.array addObject:@[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil)]];
            break;
        case allDateArray:
            self.typeLabel.text = NSLocalizedString(@"时间", nil);
            [self creatAllDate];
            break;
        case DateArray:
            self.typeLabel.text =NSLocalizedString(@"时间", nil);
            [self creatDate];
            break;
        default:
            break;
    }
}


- (void)creatDate{
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = 1900; i <= _currentYear ; i++){
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:yearArray];
    NSArray *crossLine=@[@"-"];
    [self.array addObject:crossLine];
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:monthArray];
    [self.array addObject:crossLine];
    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i ++) {
        [daysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:daysArray];
    
    [self.pickerV selectRow:[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentYear]] inComponent:0 animated:YES];
    [self.pickerV selectRow:[monthArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentMonth]] inComponent:2 animated:YES];
    [self.pickerV selectRow:[daysArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentDay]] inComponent:4 animated:YES];
}


- (void)creatAllDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = 1900; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:yearArray];
    NSArray *crossLine=@[@"-"];
    [self.array addObject:crossLine];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:monthArray];
    [self.array addObject:crossLine];
    
    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i ++) {
        [daysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.array addObject:daysArray];
    NSArray *emptyPoint=@[@" "];
    [self.array addObject:emptyPoint];
    
    NSMutableArray *hoursArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 24; i ++) {
        [hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [self.array addObject:hoursArray];
    NSArray *crossPoint=@[@":"];
    [self.array addObject:crossPoint];
    
    NSMutableArray *MinArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i ++) {
        [MinArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [self.array addObject:MinArray];
    
    [self.pickerV selectRow:[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentYear]] inComponent:0 animated:YES];
    [self.pickerV selectRow:[monthArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentMonth]] inComponent:2 animated:YES];
    [self.pickerV selectRow:[daysArray indexOfObject:[NSString stringWithFormat:@"%ld",_currentDay]] inComponent:4 animated:YES];
    
    [formatter setDateFormat:@"HH"];
    NSString *currenthour = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    NSUInteger index=[daysArray indexOfObject:currenthour]+1;
    if (index>=24) {
        index=0;
    }
    [self.pickerV selectRow:index inComponent:6 animated:YES];
    [formatter setDateFormat:@"mm"];
    NSString *currentmin = [NSString stringWithFormat:@"%02ld",(long)[[formatter stringFromDate:date]integerValue]];
    NSUInteger index2=[MinArray indexOfObject:currentmin];
    if (index2>59) {
        index2=0;
    }
    [self.pickerV selectRow:index2 inComponent:8 animated:YES];
}

#pragma mark-----UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.array.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSArray * arr = (NSArray *)[self.array objectAtIndex:component];
    if (self.arrayType == DateArray||self.arrayType == allDateArray) {
        if (component==4) {
            return _currentMonthDays;
        }
        return arr.count;
    }else{
        return arr.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    label.font=[UIFont boldSystemFontOfSize:15];
    return label;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *arr = (NSArray *)[self.array objectAtIndex:component];
    return [arr objectAtIndex:row % arr.count];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.arrayType == DateArray) {
        return 40;
    }else if (self.arrayType == allDateArray)
    {
        if (component==1||component==3||component==5||component==7) {
            return 10;
        }
        return 40;
    }else{
        if (kScreenWidth>=450) {
            return 110;
        }
        return 70;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.arrayType==allDateArray||self.arrayType==DateArray) {
        NSString *currentYear=[self getYear];
        NSString *currentMonth=[self getMonth];
        NSInteger days=[self DaysfromYear:[currentYear integerValue] andMonth:[currentMonth integerValue]];
        _currentMonthDays=days;
        [pickerView reloadComponent:4];
    }
}

#pragma mark-----点击方法
- (void)okButtonClick{
    if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:)]) {
        [self.delegate PickerSelectorIndixString:[self getCurrentPickerString]];
    }
    [self removeTimerPicker];
}

- (void)cancelBtnClick{
    [self removeTimerPicker];
}

- (void)showTimerPicker {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.pickerBackView.frame;
        frame.origin.y = kScreenHeight-260*hScale;
        self.pickerBackView.frame = frame;
    }];
}

- (void)removeTimerPicker {
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.pickerBackView.frame;
        frame.origin.y = kScreenHeight;
        self.pickerBackView.frame = frame;
        
    } completion:^(BOOL finished) {
        //判断语句必须加,否则崩溃
        if([self.delegate respondsToSelector:@selector(PickerSelectorCancel)])
        {
            [self.delegate PickerSelectorCancel];
        }
        [self.pickerBackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(NSString *)getYear {
    NSString *fullStr = [NSString string];
    fullStr=[[self getCurrentPickerString] substringToIndex:4];
    return fullStr;
}

-(NSString *)getMonth {
    NSString *fullStr = [NSString string];
    fullStr=[[self getCurrentPickerString] substringWithinBoundsLeft:@"-" right:@"-"];
    return fullStr;
}

- (NSString *)getCurrentPickerString {
    NSString *fullStr = [NSString string];
    for (int i = 0; i < self.array.count; i++)
    {
        NSArray *arr = [self.array objectAtIndex:i];
        if (self.arrayType == DateArray)
        {
            NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]% arr.count];
            if (i==self.array.count-1)
            {
                fullStr = [fullStr stringByAppendingString:str];
            }
            else
            {
                fullStr = [fullStr stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
            }
        }else if (self.arrayType==allDateArray){
            NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]% arr.count];
            if (i==self.array.count-1) {
                fullStr = [fullStr stringByAppendingString:str];
            }
            else if (i==self.array.count-2) {
                fullStr = [fullStr stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
            }
            else if (i==self.array.count-3){
                fullStr = [fullStr stringByAppendingString:[NSString stringWithFormat:@"  %@",str]];
            }else
            {
                fullStr = [fullStr stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
            }
        }else{
            NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]];
            fullStr = [fullStr stringByAppendingString:str];
        }
    }
    return fullStr;
}

- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

-(void)setTopBackColor:(UIColor *)topBackColor {
    self.topView.backgroundColor = topBackColor;
}

-(void)setTopTitleColor:(UIColor *)topTitleColor {
    [self.cancelBtn setTitleColor:topTitleColor forState:UIControlStateNormal];
    [self.OKBtn setTitleColor:topTitleColor forState:UIControlStateNormal];
    self.typeLabel.textColor = topTitleColor;
}

@end
