var isIOS;//是否IOS操作系统类型
var browser = {
    isIOS:function(){
        var u = navigator.userAgent, app = navigator.appVersion;
        if ( !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) || u.indexOf('iPhone') > -1 || u.indexOf('iPad') > -1 )
            return true;
        else return false;
    }
}
isIOS = browser.isIOS();
var syncResult = null;//IOS同步方法返回值，接收值后请及时清空
var callbackMap = new Map();//所有回调函（对象）临时数缓存在此

/**
 *公共回调函数，native端调用。所有回调函数对象均缓存到callbackMap中，此函数通过native端
 * 返回的key来找到具体回调函数对象，并完成调用，并清除缓存。
 * @param result native端返回的json数据，格式如：{"successKey":"ajax_s1234325676","failKey":"ajax_f1234325676",
     * "isSuccess":"true","response":"xx对象或字符串",
     * "token":"xxxxxxxxx","errorCode":"401","msg":"xxxxxxx"},不一定完全包含所有字段。
 */
function commonCallback(result){
    var successKey = result.successKey;
    var failKey = result.failKey;
    var successCallback = callbackMap.get(successKey);
    var failCallback = callbackMap.get(failKey);
    var isSuccess = result.isSuccess
    if(isSuccess){
        successCallback.call(this,result);
    }else{
        failCallback.call(this,result);
    }
    callbackMap.remove(successKey);
    callbackMap.remove(failKey);
}

/**
 *存储键值对的Map数据结构对象
 * @constructor
 */
function Map() {
    this.elements = new Array();
    this.size = function() {
        return this.elements.length;
    };
    this.isEmpty = function() {
        return (this.elements.length < 1);
    };
    this.clear = function() {
        this.elements = new Array();
    };
    this.put = function(key,value) {
        this.elements.push( {
            key :key,
            value :value
        });
    };
    this.remove = function(key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    this.get = function(key) {
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == key) {
                    return this.elements[i].value;
                }
            }
        } catch (e) {
            return null;
        }
    };
    this.element = function(index) {
        if (index < 0 || index >= this.elements.length) {
            return null;
        }
        return this.elements[index];
    };
    this.containsKey = function(key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == key) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    this.containsValue = function(value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == value) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    this.values = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].value);
        }
        return arr;
    };
    this.keys = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].key);
        }
        return arr;
    };
}

/**
 * 异步网络请求函数，完成ajax功能。
 * @param obj 请求参数对象，格式为：
 * { url:"http://....",
     *  timeout：30000,
     *  method：post,
     *  data:{xx:yy,...},
     *  header:"xxxx",
     *  dataCharset:"UTF-8",
     *  contentType:"application/xml",
     *  success:callback function,
     *  fail:callback function
     *  }
 *  url不能为空，回调函数可以为空，其他各项可以为空，但会使用默认值。
 */
function ch_ajax(obj){
    if(!obj.url){
        window.Native.alert("请求地址不能为空！");
        return;
    }
    this.timeout = 60000;
    if(obj.timeout){
        this.timeout = obj.timeout;
    }
    this.method = "post";
    if(obj.method){
        this.method = obj.method;
    }
    this.data = "";
    if(obj.data){
        this.data = obj.data;
    }
    this.header = "";
    if(obj.header){
        this.header = obj.header;
    }
    this.dataCharset = "UTF-8";
    if(obj.dataCharset){
        this.dataCharset = obj.dataCharset;
    }
    this.contentType = "application/json";
    if(obj.contentType){
        this.contentType = obj.contentType;
    }
    this.url = obj.url;
    this.successKey = "";
    this.failKey = "";
    this.success = null;
    if(obj.success){
        this.success = obj.success;
        this.successKey = "ajax_s" + new Date().getTime();
        callbackMap.put(successKey,this.success);
    }
    this.fail = null;
    if(obj.fail){
        this.fail = obj.fail;
        this.failKey = "ajax_f" + new Date().getTime();
        callbackMap.put(failKey,this.fail);
    }
    if(isIOS){
        var param = '[{"successKey":"' + this.successKey + '","failKey":"' + this.failKey
            + '"},{"timeout":"' + this.timeout + '"},{"method":"' + this.method + '"},{"data":"'
            + this.data + '"},{"dataCharset":"' + this.dataCharset + '"},{"header":"'
            + this.header + '"},{"contentType":"' + this.contentType + '"},{"url":"' + this.url + '"}]';
        window.location = encodeURI("http://com.changhong.native.async/networkRequest:timeout" +
                                        ":method:data:dataCharset:header:contentType:url:?param=" + param);
    }else{
        window.Native.networkRequest(this.timeout,this.method,this.data,this.dataCharset,
            this.header,this.contentType,this.url,this.successKey,this.failKey);
    }
    this.successKey = "";
    this.failKey = "";
    return true;
}