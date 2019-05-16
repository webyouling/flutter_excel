#import "FlutterExcelPlugin.h"

@implementation FlutterExcelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_excel"
            binaryMessenger:[registrar messenger]];
  FlutterExcelPlugin* instance = [[FlutterExcelPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"exportData" isEqualToString:call.method]){
      NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
      NSString *jsonString = call.arguments[@"infodata"];
      NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
      NSError *err;
      //字符串转数组
      NSArray *jsonDataArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                             error:&err];
      // 第一行内容
      [xlsDataMuArr addObject:@"type"];
      [xlsDataMuArr addObject:@"content"];
      [xlsDataMuArr addObject:@"time"];
      for (NSDictionary *item in jsonDataArr) {
          [xlsDataMuArr addObject:item[@"type"]];
          [xlsDataMuArr addObject:item[@"content"]];
          [xlsDataMuArr addObject:item[@"time"]];
      }
      // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
      NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
      // 字符串转换为可变字符串，方便改变某些字符
      NSMutableString *muStr = [fileContent mutableCopy];
      // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
      NSMutableArray *subMuArr = [NSMutableArray array];
      for (int i = 0; i < muStr.length; i ++) {
          NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
          if (range.length == 1) {
              [subMuArr addObject:@(range.location)];
          }
      }
      // 替换末尾\t
      for (NSUInteger i = 0; i < subMuArr.count; i ++) {
      #warning  下面的3是列数，根据需求修改
          if ( i > 0 && (i%3 == 0) ) {
              [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
          }
      }
      // 文件管理器
      NSFileManager *fileManager = [[NSFileManager alloc]init];
      //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
      NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
      // 文件路径
      NSString *path = NSHomeDirectory();
      NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
      NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
      NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
      NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@.xls",timeString]];
      NSLog(@"文件路径：\n%@",filePath);
     // 生成xls文件
      [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
      if([self isFileExist:filePath ]){
          result(filePath);
      }else{
          result(nil);
      }
  }else {
    result(FlutterMethodNotImplemented);
  }
}

-(BOOL) isFileExist:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:fileName];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

@end
