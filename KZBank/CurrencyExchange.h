#import "BaseObject.h"

@interface CurrencyExchange : BaseObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double value;
@property (nonatomic, strong) NSDate *date;

+ (NSArray*)calculateData;

- (double)min;
- (double)max;
- (NSString*)change;
- (double)currentValue;
- (NSArray*)last30;

@end
