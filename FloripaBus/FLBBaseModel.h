//
//  FLBBaseModel.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLBBaseModel : NSObject
{
    NSDictionary *attrs;
}

@property (strong) NSDictionary *attrs;

- (id)initWithAttrs:(NSDictionary *) attributes;

- (NSInteger) ID;

- (NSString *) returnNSString:(id)object;
- (NSInteger) returnNSInteger:(id)object;
- (CGFloat) returnCGFloat:(id)object;
- (BOOL) returnBOOL:(id)object;
- (NSDate *) returnNSDate:(id)object withFormat:(NSString *)format;
- (NSDate *) returnNSDate:(id)object;
- (NSDate *) returnNSDateFromTimeInterval:(id)object;
- (NSDictionary *) returnNSDictionary:(id)object;
- (NSArray *) returnNSArray:(id)object;
- (NSArray *) returnNSArray:(id)object withObjectType:(Class) type;
- (FLBBaseModel *) returnObject:(id)object withType:(Class) type;


- (void)encodeWithCoder:(NSCoder *)coder;
- (id) initWithCoder: (NSCoder *)coder;

@end
