abort() {
   echo "$@"
   sleep 1
   exit 1
}

Inject() {
    [[ ! -x "`curl -where`" ]] && Install_Curl
    curl -L -s -o "$2" "$CODING/$1"
}

Install_Curl() {
        echo "- curl不存在，开始下载"
        wget --no-check-certificate -nv -O $ELF1_Path/curl3 "https://file.qqcn.xyz/GJZS/Other/Curl/`getprop ro.product.cpu.abi`"
        [[ ! -d "~/Configuration_File" ]] && mkdir ~/Configuration_File
        wget --no-check-certificate -nv -O ~/Configuration_File/cacert.pem "https://file.qqcn.xyz/GJZS/Other/Curl/cacert.pem"
        chmod +x $ELF1_Path/curl3
}


SCRIPT() {
   if [[ ! -f $2 ]]; then
      Inject $1 $2
      Check_MD5=`md5sum $2 2>/dev/null | sed 's/ .*//g'`
         if [[ $Check_MD5 = $3 ]]; then
            echo "- 初始化$4成功"
         else
            rm -f $2
            echo "！ 初始化$4失败"
         fi
    elif [[ -f $2 ]]; then
      Check_MD5=`md5sum $2 2>/dev/null | sed 's/ .*//g'`
         if [[ $Check_MD5 != $3 ]]; then
           Inject $1 $2
            Check_MD5=`md5sum $2 | sed 's/ .*//g'`
               if [[ $Check_MD5 = $3 ]]; then
                  echo "- 更新$4成功"
               else
                  rm -f $2
                  echo "- 更新$4失败"
               fi
         fi
     fi
}

DATA() {
    echo "- 开始检测脚本更新"
    Inject data.php "$data_MD5"
    sleep 1
}
DATA
if [[ -f $data_MD5 ]]; then
  . $data_MD5
  if [[ $? -ne 0 ]]; then
     echo -e "\n！服务器已过期（error：404）"
     echo "请前往「搞机助手」群更新至最新版本﻿⊙∀⊙！"
     sleep 3
     echo -e "\n\n错误详情`cat $data_MD5`"
     sleep 3
     exit 6
  fi
     PeiZhi_File=$Data_Dir
     if [[ ! -d $PeiZhi_File ]]; then
        mkdir -p $PeiZhi_File
        chown $APP_USER_ID:$APP_USER_ID $PeiZhi_File
     fi
        if [[ ! -f ~/offline2 ]];then
            SCRIPT $init_data_ID "$Load" $init_data_MD5 配置
            if [[ ! -f ~/offline ]];then
              SCRIPT $APP_Version_ID "$ShellScript/APP_Version.sh" $APP_Version_MD5 版本信息
              . $ShellScript/APP_Version.sh
            fi
        fi
        [[ -f ~/offline2 || ! -f $Load ]] && cp -f $Load.bak $Load
else
  echo "！未连接到互联网❓"
fi
  . $Core
  Installing_Busybox
  echo "- 完成！"
  exit 0
