//
//  Task.h
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

// Task.h

#import <Foundation/Foundation.h>

@interface Task : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *uId;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (instancetype)initWithCoder:(NSCoder *)decoder;
@end


