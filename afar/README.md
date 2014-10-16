afar
====

抓取chrome插件[远方 New Tab](https://chrome.google.com/webstore/detail/dream-afar-new-tab/henmfoppjjkcencpbjaigfahdjlgpegn?hl=zh-CN) 的背景图片的脚本

图片很不错，不过和speed dial类的插件不能共存，写了个脚本把图片抓下来当壁纸随机切换

afar的配置文件是json格式，在shell里面用正则提取的配置，可能哪天就不能用了

默认的保存路径是 $HOME/Pictures/afar

图片下载有0.5s的间隔，会根据文件名判断文件下载过没有，如果下载过不会重复下载
