//
//  NSDate+CBDate.m
//  CBDate
//
//  Created by Henry Tseng on 2013/12/6.
//  Copyright (c) 2013年 Henry Tseng. All rights reserved.
//

#import "NSDate+CBDate.h"
#import <objc/runtime.h>
@implementation NSDate (CBDate)

- (void) setStartDayOfWeek:(WEEKDAY)startDayOfWeek
{
    objc_setAssociatedObject(self, @"startDayOfWeek", @(startDayOfWeek), OBJC_ASSOCIATION_ASSIGN); // Setter by objc/runtime
}

- (WEEKDAY) startDayOfWeek
{
    NSNumber *value = objc_getAssociatedObject(self, @"startDayOfWeek");
    if (value != nil) {
        return [value integerValue];
    }
    return SUNDAY; // default by Sunday
}

- (void) setCalendar:(NSCalendar *)calendar
{
    objc_setAssociatedObject(self, @"calendar", calendar, OBJC_ASSOCIATION_RETAIN); // Setter by objc/runtime
}

- (NSCalendar *) calendar
{
    NSCalendar *__calendar = objc_getAssociatedObject(self, @"calendar");
    if (__calendar) {
        return __calendar;
    }
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // default by GregorianCalendar
}

- (NSDate *) date
{
    NSDateComponents *comp = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *date = [self.calendar dateFromComponents:comp];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) dateByAppendDays:(NSInteger)days
{
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = days;
    NSDate *date = [self.calendar dateByAddingComponents:offset toDate:self options:0];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) dateByAppendMonths:(NSInteger)months
{
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.month = months;
    NSDate *date = [self.calendar dateByAddingComponents:offset toDate:self options:0];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) dateOfWeek:(WEEKDAY)weekday
{
    NSDateComponents *comp = [self.calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = -(comp.weekday - weekday);
    if (self.startDayOfWeek > weekday) {
        offset.day += 7;
    }
    NSDate *date = [self.calendar dateByAddingComponents:offset toDate:self options:0];
    date.calendar = self.calendar;
    return date;
}

- (NSString *) dateStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter stringFromDate:self];
}

- (NSDate *) lastDayOfMonth
{
    NSDateComponents *components = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    components.month += 1;
    components.day = 0;
    NSDate *date = [self.calendar dateFromComponents:components];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) firstDayOfMonth
{
    NSDateComponents *components = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    components.day = 1;
    NSDate *date = [self.calendar dateFromComponents:components];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) lastDayOfYear
{
    NSDateComponents *components = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    components.year += 1;
    components.month = 1;
    components.day = 0;
    NSDate *date = [self.calendar dateFromComponents:components];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) firstDayOfYear
{
    NSDateComponents *components = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    components.month = 1;
    components.day = 1;
    NSDate *date = [self.calendar dateFromComponents:components];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) yesterday
{
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = -1;
    NSDate *date = [self.calendar dateByAddingComponents:offset toDate:[self date] options:0];
    date.calendar = self.calendar;
    return date;
}

- (NSDate *) tomorrow
{
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = 1;
    NSDate *date = [self.calendar dateByAddingComponents:offset toDate:[self date] options:0];
    date.calendar = self.calendar;
    return date;
}

- (NSArray *) datesBetweenWith:(NSDate *)date
{
    NSMutableArray *results = [NSMutableArray array];
    if ([self compare:date] == NSOrderedAscending) {
        NSDate *fromDate = [self date];
        while ([fromDate compare:date] != NSOrderedDescending) {
            [results addObject:[fromDate copy]];
            fromDate = [fromDate tomorrow];
        }
    } else if ([self compare:date] == NSOrderedDescending) {
        NSDate *fromDate = [date date];
        while ([fromDate compare:self] != NSOrderedDescending) {
            [results addObject:[fromDate copy]];
            fromDate = [fromDate tomorrow];
        }
    } else {
        [results addObject:[self date]];
    }
    return [NSArray arrayWithArray:results];
}

+ (NSArray *) datesBetweenWith:(NSDate *)startDate and:(NSDate *)endDate
{
    NSMutableArray *results = [NSMutableArray array];
    if ([startDate compare:endDate] == NSOrderedAscending) {
        NSDate *fromDate = [startDate date];
        while ([fromDate compare:endDate] != NSOrderedDescending) {
            [results addObject:[fromDate copy]];
            fromDate = [fromDate tomorrow];
        }
    } else if ([startDate compare:endDate] == NSOrderedDescending) {
        NSDate *fromDate = [endDate date];
        while ([fromDate compare:startDate] != NSOrderedDescending) {
            [results addObject:[fromDate copy]];
            fromDate = [fromDate tomorrow];
        }
    } else {
        [results addObject:[startDate date]];
    }
    return [NSArray arrayWithArray:results];
}

- (NSInteger) daysBetweenWith:(NSDate *)date
{
    NSDateComponents *offset = [self.calendar components:(NSDayCalendarUnit) fromDate:self toDate:date options:0];
    return offset.day;
}

+ (NSInteger) daysBetweenWith:(NSDate *)startDate and:(NSDate *)endDate
{
    NSDateComponents *offset = [startDate.calendar components:(NSDayCalendarUnit) fromDate:startDate toDate:endDate options:0];
    return offset.day;
}

- (NSDateComponents*) timesBetweenWith:(NSDate *)date
{
    NSDateComponents *offset = [self.calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:self toDate:date options:0];
    return offset;
}

+ (NSDateComponents*) timesBetweenWith:(NSDate *)startDate and:(NSDate *)endDate
{
    NSDateComponents *offset = [startDate.calendar components:(NSHourCalendarUnit) fromDate:startDate toDate:endDate options:0];
    return offset;
}

@end
