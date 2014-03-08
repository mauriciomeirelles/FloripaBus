//
//  FLBBaseModel.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBBaseModel.h"

@implementation FLBBaseModel
@synthesize attrs;

- (id)initWithAttrs:(NSDictionary *) attributes
{
    self = [super init];
    if (self)
    {
        attrs = attributes;
    }
    
    return self;
}

- (NSString *) description
{
    return attrs.description;
}

- (NSInteger) ID
{
    return [self returnNSInteger:[attrs objectForKey:@"id"]];
}

- (NSString *)returnNSString:(id)object
{
    if (object != [NSNull null])
        return object;
    else
    {
        NSString *a;
        return a;
    }
}

- (NSInteger)returnNSInteger:(id)object
{
    if (object != [NSNull null])
        return [object integerValue];
    else
    {
        NSInteger a = 0;
        return a;
    }
}

- (CGFloat)returnCGFloat:(id)object
{
    if (object != [NSNull null])
        return [object floatValue];
    else
    {
        CGFloat a = 0.0;
        return a;
    }
}

- (BOOL)returnBOOL:(id)object
{
    if (object != [NSNull null])
        return [object boolValue];
    else
    {
        return NO;
    }
}

- (NSDate *)returnNSDate:(id)object withFormat:(NSString *)format
{
    if (object != [NSNull null])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
        //[dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormat setDateFormat:format];
        return [dateFormat dateFromString:object];
    }
    else
    {
        NSDate *a;
        return a;
    }
}

- (NSDate *)returnNSDate:(id)object
{
    return [self returnNSDate:object withFormat:@"yyyy-MM-ddTHH:mm:ssTZD"];
}

- (NSDate *) returnNSDateFromTimeInterval:(id)object
{
    if (object != [NSNull null])
    {
        NSDate *a = [NSDate dateWithTimeIntervalSince1970:[object longLongValue]];
        return a;
    }
    else
    {
        NSDate *a;
        return a;
    }
}

- (NSDictionary *)returnNSDictionary:(id)object
{
    if (object != [NSNull null])
        return (NSDictionary *)object;
    else
    {
        NSDictionary *a;
        return a;
    }
}

- (NSArray *)returnNSArray:(id)object
{
    if (object != [NSNull null])
        return (NSArray *)object;
    else
    {
        NSArray *a;
        return a;
    }
}

- (NSArray *) returnNSArray:(id)object withObjectType:(Class) type
{
    if (object != [NSNull null])
    {
        NSMutableArray *arrayAux = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in object)
        {
            [arrayAux addObject:[self returnObject:dict withType:type]];
        }
        
        return arrayAux;
    }
    else
    {
        NSArray *a;
        return a;
    }
}

- (FLBBaseModel *) returnObject:(id)object withType:(Class) type {
    if (object != [NSNull null])
    {
        FLBBaseModel *a = [[type alloc] initWithAttrs:object];
        return a;
    }
    else
    {
        FLBBaseModel *a;
        return a;
    }
}


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:attrs forKey:@"attrs"];
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.attrs = [coder decodeObjectForKey:@"attrs"];
    }
    
    return self; // this is missing in the example above
    
    
}


@end
