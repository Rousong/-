# -


拷贝一份supervisor的配置文件到etc目录下 
echo_supervisord_conf > /etc/supervisord.conf

加上includ包含

[include]
files = /www/supervisor/*.conf

在上面的目录下创建自己的conf文件

[program:2zzy]
command = bash /www/start2zzy.sh
user = root
autostart=true
autorestart=true

redirect_stderr = true
stdout_logfile = /www/logs2zzy/robot.log
stderr_logfile=/www/logs2zzy/err.log


通过 supervisord -c /etc/supervisord.conf 来读取配置
保存各种配置文件
supervisorctl update

supervisorctl reload

supervisorctl status



输入supervisorctl 进入命令行

	* status # 查看程序状态
	* 
stop testpy # 关闭 testpy 程序
	* 
start testpy # 启动 testpy 程序
	* 
restart testpy # 重启 testpy 程序
	* 
reread ＃ 读取有更新（增加）的配置文件，不会启动新添加的程序
	* 
update ＃ 重启配置文件修改过的程序


centos7是打算放弃/etc/rc.local了。

本来想开机启动一个脚本，命令写入了rc.local，也给了权限，但就是不起作用。

centos
### 新建文件supervisord.service

#supervisord.service

[Unit] 
Description=Supervisor daemon

[Service] 
Type=forking 
ExecStart=/usr/bin/supervisord -c /etc/supervisord.conf 
ExecStop=/usr/bin/supervisorctl shutdown 
ExecReload=/usr/bin/supervisorctl reload 
KillMode=process 
Restart=on-failure 
RestartSec=42s

[Install] 
WantedBy=multi-user.target



### 将文件拷贝到/usr/lib/systemd/system/

cp supervisord.service /usr/lib/systemd/system/


### 启动服务

systemctl enable supervisord



### 验证一下是否为开机启动

systemctl is-enabled supervisord
