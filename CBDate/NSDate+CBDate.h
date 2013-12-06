//
//  NSDate+CBDate.h
//  CBDate
//
//  Created by Henry Tseng on 2013/12/6.
//  Copyright (c) 2013年 Henry Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SUNDAY = 1,
    MONDAY = 2,
    TUESDAY = 3,
    WEDNESDAY = 4,
    THURSDAY = 5,
    FRIDAY = 6,
    SATURDAY = 7
} WEEKDAY;

@interface NSDate (CBDate)
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) WEEKDAY startDayOfWeek;
- (NSDate *) date;
- (NSDate *) dateByAppendDays:(NSInteger)days;
- (NSDate *) dateByAppendMonths:(NSInteger)months;
- (NSDate *) dateOfWeek:(WEEKDAY)weekday;
- (NSDate *) lastDayOfMonth;
- (NSDate *) firstDayOfMonth;
- (NSDate *) lastDayOfYear;
- (NSDate *) firstDayOfYear;
- (NSDate *) yesterday;
- (NSDate *) tomorrow;
- (NSString *) dateStringWithFormat:(NSString*)format;
- (NSArray *) datesBetweenWith:(NSDate *)date;
+ (NSArray *) datesBetweenWith:(NSDate *)startDate and:(NSDate*)endDate;
- (NSInteger) daysBetweenWith:(NSDate *)date;
+ (NSInteger) daysBetweenWith:(NSDate *)startDate and:(NSDate *)endDate;
- (NSDateComponents*) timesBetweenWith:(NSDate *)date;
+ (NSDateComponents*) timesBetweenWith:(NSDate *)startDate and:(NSDate *)endDate;
@end
