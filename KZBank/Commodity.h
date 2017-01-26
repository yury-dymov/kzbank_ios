#import "BaseObject.h"

@interface Commodity : BaseObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) double value;

+ (NSArray*)calculateData;

- (double)min;
- (double)max;
- (NSString*)change;
- (double)currentValue;
- (NSArray*)last30;


@end
