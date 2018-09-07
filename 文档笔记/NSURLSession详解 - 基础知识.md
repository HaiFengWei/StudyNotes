#NSURLSession详解 - 基础知识
##简介
1、**NSURLSession**在2013年随着iOS7的发布一起面世，苹果对它的定位是作为**NSURLConnection**的替代者

2、**Session**翻译为中文意思是会话，我们知道，在七层网络协议中有**物理层->数据链路层->网络层->传输层->会话层->表示层->应用层**，那我们可以将**NSURLSession**类理解为会话层，用于管理网络接口的创建、维护、删除等等工作，我们要做的工作也只是会话层之后的层即可，底层的工作**NSURLSession**已经帮我们封装好了

3、另外还有一些**Session**，比如**AVAudioSession**用于音视频访问，**WCSession**用于**WatchOS**通讯，它们都是建立一个会话，并管理会话，封装一些底层，方便我们使用

##基本知识
###1、NSUrl简介
URL(统一资源定位符) ,指定资源位置。

~~~objc
    /**
     协议：不同的协议，代表着不同的资源查找方式、资源传输方式，比如常用的http，ftp等
     主机地址：存放资源的主机的IP地址（域名）
     路径：资源在主机中的具体位置
     参数：参数可有可无，也可以多个。如果带参数的话，用“?”号后面接参数，多个参数的话之间用&隔开
     */
    NSURL *url = [NSURL URLWithString:@"协议://主机地址/路径?参数&参数"];
~~~
示例：

~~~objc
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/search?id=1"];
    //协议 http 
    NSLog(@"scheme:%@", [url scheme]);
    
    //域名 www.baidu.com 
    NSLog(@"host:%@", [url host]);
    
    //完整的url字符串 http://www.baidu.com:8080/search?id=1
    NSLog(@"absoluteString:%@", [url absoluteString]);
    
    //相对路径 search 
    NSLog(@"relativePath: %@", [url relativePath]);
    
    //端口号 
    NSLog(@"port :%@", [url port]);
    
    //路径 search 
    NSLog(@"path: %@", [url path]);
    
    //search 
    NSLog(@"pathComponents:%@", [url pathComponents]);
    
    //参数 id=1 
    NSLog(@"Query:%@", [url query]);
~~~

###2、NSURLRequest简介
####简介：
一个独立的独立加载请求的协议和解决方案，它封装了 **load URL** 和 **the policy**，当你发送了网络请求时候可以使用缓存，你可以通过它 **propertyForKey:inRequest:** 和 **setProperty:forKey:inRequest:**.这两个方法添加你的协议

####使用：
```objc
NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
```

#####2.1、url：资源路径
#####2.2、cachePolicy：缓存策略（无论使用哪种缓存策略，都会在本地缓存数据），类型为枚举类型，取值如下：

```objc
NSURLRequestUseProtocolCachePolicy = 0       //默认的缓存策略，使用协议的缓存策略
NSURLRequestReloadIgnoringLocalCacheData = 1 //每次都从网络加载
NSURLRequestReturnCacheDataElseLoad = 2      //返回缓存否则加载，很少使用
NSURLRequestReturnCacheDataDontLoad = 3      //只返回缓存，没有也不加载，很少使用

```
#####2.3、timeoutInterval：超时时长，默认60s，这里设置为30s

#####2.4、基础属性：

```objc
// HPPT请求方式 默认为“GET”
@property (copy) NSString *HTTPMethod;

//通过字典设置HTTP请求头的键值数据
@property (nullable, copy) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;

//设置http请求头中的字段值
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;

//向http请求头中添加一个字段
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

//设置http请求体 用于POST请求
@property (nullable, copy) NSData *HTTPBody;

//设置http请求体的输入流
@property (nullable, retain) NSInputStream *HTTPBodyStream;

//设置发送请求时是否发送cookie数据
@property BOOL HTTPShouldHandleCookies;

//设置请求时是否按顺序收发 默认禁用 在某些服务器中设为YES可以提高网络性能
@property BOOL HTTPShouldUsePipelining;
```
####示例：
```objc
    /** GET方式 */
    NSString *urlString = [NSString stringWithFormat:@"http://jssb.zust.edu.cn/androidLogin.action?id=%@&password=%@&role=%@",@"admin02",@"admin02",@"dean"];
    
    //创建URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //创建request实例对象
    NSURLRequest *request = [[NSURLRequest requestWithURL:url];
    
    
    

   /** POST方式 */
	NSString *urlString = [NSString stringWithFormat:@"http://jssb.zust.edu.cn/androidLogin.action"];
	
    //创建request可变实例对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    // 设置url
    [request setURL:[NSURL URLWithString:urlString]];
    
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 设置请求头
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // 设置请求提
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"id=%@&password=%@&role=%@",@"admin02",@"admin02",@"dean"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
```




