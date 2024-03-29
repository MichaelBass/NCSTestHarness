//
//  FlankerDataParser.h
//  NCS
//

#import <Foundation/Foundation.h>
#import <AssessmentModel/BaseParser.h>

@interface FlankerDataParser : BaseParser
{
    NSMutableArray* _itemList;
    NSMutableDictionary* _parameterDictionary;
}

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict;

+ (NSMutableArray*) parseFormFile;

@end
