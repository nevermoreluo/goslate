


## Goslate

### 写在前面  
由于google项目全面收费，因此该项目代码目前已不适合批量使用
仅做学习参考
项目源自https://bitbucket.org/zhuoqiang/goslate。
此项目仅是一份fork，用于日后的学习使用，源自[bitbucket](https://bitbucket.org/zhuoqiang/goslate)。
Goslate (Google Translate)利用谷歌API翻译，
（google API 那么问题来了 墙内同学需要自行挂代理，goslate支持代理）
以下是简要说明

### 代理

proxy-domain.name改为代理域名或IP。

```python
import urllib2
import goslate

proxy_handler = urllib2.ProxyHandler({"http" : "http://proxy-domain.name:8080"})
proxy_opener = urllib2.build_opener(urllib2.HTTPHandler(proxy_handler),
                                    urllib2.HTTPSHandler(proxy_handler))

gs_with_proxy = goslate.Goslate(opener=proxy_opener)
translation = gs_with_proxy.translate("hello world", "de")
```

### 使用  

Goslate 支持 Python2.6 以上版本，包括 Python3！你可以通过 pip 或 easy_install 安装
你也可以直接下载最新版本的[goslate.py](https://bitbucket.org/zhuoqiang/goslate/raw/tip/goslate.py) 。使用很简单，下面是英译德的例子

```bash
# 安装 goslate
$ pip install goslate

#进入python环境
$ python
>>> import goslate
>>> gs = goslate.Goslate()
>>> print gs.translate('hello world', 'de')
hallo welt


# 当然你也可以直接使用它
# 通过标准输入英译汉输出到屏幕
$ echo "hello world" | goslate.py -t zh-CN
# 翻译两个文件，将结果用 UTF-8 编码保存到 out.txt
$ goslate.py -t zh-CN -o utf-8 src/1.txt "src 2.txt" > out.txt

# 更多用法可以输入-h查看
$ goslate.py -h
```

希望查看更多用法的可以参看[文档](http://pythonhosted.org/goslate/)。  

### 原理简述  

要使用谷歌翻译官方API需要先付费获得Key。如果Key非法，谷歌API就会返回错误403或者其他。

用浏览器去谷歌翻译hello world，抓包发现，浏览器访问了这个URL：

http://translate.google.com/translate_a/t?client=t&hl=en&sl=en&tl=zh-CN&ie=UTF-8&oe=UTF-8&multires=1&prev=conf&psl=en&ptl=en&otf=1&it=sel.2016&ssel=0&tsel=0&prev=enter&oc=3&ssel=0&tsel=0&sc=1&text=hello%20world
很容易看出源文本是作为text参数直接编码在 URL 中的。而相应的 tl 参数表示 translate language，这里是 zh-CN （简体中文）。

谷歌翻译返回：

{"sentences":[{"trans":"世界，你好！","orig":"hello world!","translit":"Shìjiè, nǐ hǎo!","src_translit":""},{"trans":"认识你很高兴。","orig":"nice to meet you.","translit":"Rènshi nǐ hěn gāoxìng.","src_translit":""}],"src":"en","server_time":48}
格式类似 JSON，但不标准。其中不但有翻译结果，还包含汉语拼音和源文本的语言等附加信息。

这个过程很简单，我们的爬虫逻辑是
先把源文本和目标语言组成类似上面的 URL
再用 python 的 urllib2 去到谷歌翻译站点上 HTTP GET 结果
拿到返回数据后再把翻译结果单独抽取出来
有一点要注意，谷歌很不喜欢 python 爬虫：） 它会禁掉所有 User-Agent 是 Python-urllib/2.7 的 HTTP 请求。我们要伪装成浏览器 User-Agent: Mozilla/4.0 来让谷歌放心。另外还有一个小窍门，URL 中可将参数 client 从 t 改成其它值，返回的就是标准 JSON 格式，方便解析结果。




