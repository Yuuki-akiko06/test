#!/bin/bash


# Download Azur Lane
# Download Azur Lane
download_azurlane () {
    if [ ! -f "AzurLane.apk" ]; then
    # 这个链接是oppo下载的,应该是9游,其他渠道自行修改直链
    #url="https://download.cowcs.com/cowtransfer/cowtransfer/84809/ad0f1ab75aa64a12a79ee2fe6e8151ab.apk?auth_key=1679852296-fcd7753f20744f0e930518fe98c9504f-0-5a3b56cdd14e4ef8713064f926668eca&biz_type=1&business_code=COW_TRANSFER&channel_code=COW_CN_WEB&response-content-disposition=attachment%3B%20filename%3D23214782.apk%3Bfilename*%3Dutf-8%27%2723214782.apk&user_id=1023565177469684809&x-verify=1"
    #这个链接是oppo
    #url="https://download.cowcs.com/cowtransfer/cowtransfer/84809/ad0f1ab75aa64a12a79ee2fe6e8151ab.apk?auth_key=1679852296-fcd7753f20744f0e930518fe98c9504f-0-5a3b56cdd14e4ef8713064f926668eca&biz_type=1&business_code=COW_TRANSFER&channel_code=COW_CN_WEB&response-content-disposition=attachment%3B%20filename%3D23214782.apk%3Bfilename*%3Dutf-8%27%2723214782.apk&user_id=1023565177469684809&x-verify=1"
    # 使用curl命令下载apk文件
    #curl -o blhx.apk  $url
    
    url="https://github.com/liusj5257/azurlane_anti_name/releases/download/%E5%BD%93%E4%B9%90%E6%B8%A0%E9%81%93/dangle.AzurLane.patched.apk"
    curl -o blhx.apk -L $url
    
    fi
}

if [ ! -f "AzurLane.apk" ]; then
    echo "Get Azur Lane apk"
    download_azurlane
    mv *.apk "AzurLane.apk"
fi


echo "Decompile Azur Lane apk"
java -jar apktool.jar  -f d AzurLane.apk

echo "Copy libs"
cp -r libs/. AzurLane/lib/

echo "Patching Azur Lane"
oncreate=$(grep -n -m 1 'onCreate' AzurLane/smali/com/unity3d/player/UnityPlayerActivity.smali | sed  's/[0-9]*\:\(.*\)/\1/')
sed -ir "s#\($oncreate\)#.method private static native init(Landroid/content/Context;)V\n.end method\n\n\1#" AzurLane/smali/com/unity3d/player/UnityPlayerActivity.smali
sed -ir "s#\($oncreate\)#\1\n    const-string v0, \"Dev_Liu\"\n\n\    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V\n\n    invoke-static {p0}, Lcom/unity3d/player/UnityPlayerActivity;->init(Landroid/content/Context;)V\n#" AzurLane/smali/com/unity3d/player/UnityPlayerActivity.smali

echo "Build Patched Azur Lane apk"
java -jar apktool.jar  -f b AzurLane -o AzurLane.patched.apk

echo "Set Github Release version"

echo "PERSEUS_VERSION=$(echo Ship_Name)" >> $GITHUB_ENV

mkdir -p build
mv *.patched.apk ./build/
find . -name "*.apk" -print
