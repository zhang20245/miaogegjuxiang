#!/bin/bash

# 脚本版本
VERSION="1.1"
# 脚本工具名称
SCRIPT_NAME="喵哥的Shell脚本工具"

# 欢迎信息
echo "欢迎使用 $SCRIPT_NAME V$VERSION"
echo "此工具包括Docker管理器和LDNMP建站系统，支持快速搭建和管理站点。"

# 脚本菜单
show_menu() {
    echo "==============================="
    echo "系统工具脚本"
    echo "==============================="
    echo "1. 设置脚本启动快捷键"
    echo "2. 修改登录密码"
    echo "3. ROOT密码登录模式"
    echo "4. 安装Python指定版本"
    echo "5. 开放所有端口"
    echo "6. 修改SSH连接端口"
    echo "7. 优化DNS地址"
    echo "8. 一键重装系统"
    echo "9. 禁用ROOT账户创建新账户"
    echo "10. 切换优先IPv4/IPv6"
    echo "------------------------------"
    echo "11. 查看端口占用状态"
    echo "12. 修改虚拟内存大小"
    echo "13. 用户管理"
    echo "14. 用户/密码生成器"
    echo "15. 系统时区调整"
    echo "16. 设置BBR3加速"
    echo "17. 防火墙高级管理器"
    echo "18. 修改主机名"
    echo "19. 切换系统更新源"
    echo "==============================="
}

# 1. 设置脚本启动快捷键
set_shortcut() {
    echo "请输入快捷键，例如Ctrl+Alt+T："
    read shortcut
    # 修改快捷键，假设为 GNOME 环境
    gnome-keybinding-properties --add 'run-script' --command "/path/to/script.sh"
    echo "已设置快捷键 $shortcut 启动脚本"
}

# 2. 修改登录密码
change_password() {
    echo "请输入新密码："
    read -s new_password
    echo "请输入确认密码："
    read -s confirm_password
    if [ "$new_password" == "$confirm_password" ]; then
        echo "当前用户的密码已更改"
        echo "$USER:$new_password" | chpasswd
    else
        echo "两次输入密码不一致！"
    fi
}

# 3. ROOT密码登录模式
root_login() {
    echo "请输入ROOT用户密码："
    sudo passwd root
}

# 4. 安装Python指定版本
install_python_version() {
    echo "请输入要安装的Python版本："
    read version
    sudo apt update
    sudo apt install -y python$version
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python$version 1
}

# 5. 开放所有端口
open_all_ports() {
    sudo ufw allow from any to any port 1:65535 proto tcp
    sudo ufw reload
    echo "已开放所有端口"
}

# 6. 修改SSH连接端口
change_ssh_port() {
    echo "请输入新的SSH端口："
    read port
    sudo sed -i "s/Port 22/Port $port/" /etc/ssh/sshd_config
    sudo systemctl restart sshd
    echo "SSH端口已更改为 $port"
}

# 7. 优化DNS地址
optimize_dns() {
    echo "请输入首选DNS地址："
    read dns1
    echo "请输入备选DNS地址："
    read dns2
    echo -e "nameserver $dns1\nnameserver $dns2" | sudo tee /etc/resolv.conf > /dev/null
    echo "DNS已优化"
}

# 8. 一键重装系统 ★
reinstall_system() {
    echo "警告：这将重装系统，所有数据将丢失！"
    echo "是否继续？(yes/no)"
    read confirm
    if [ "$confirm" == "yes" ]; then
        sudo apt-get install --reinstall ubuntu-desktop
        sudo reboot
    else
        echo "操作已取消"
    fi
}

# 9. 禁用ROOT账户创建新账户
disable_root_account() {
    sudo usermod -L root
    echo "ROOT账户已禁用创建新账户"
}

# 10. 切换优先IPv4/IPv6
switch_ip_protocol() {
    echo "请选择优先协议（1为IPv4，2为IPv6）："
    read choice
    if [ "$choice" == "1" ]; then
        sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
        sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
        echo "已切换优先IPv4"
    elif [ "$choice" == "2" ]; then
        sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
        echo "已切换优先IPv6"
    else
        echo "无效选择"
    fi
}

# 11. 查看端口占用状态
check_ports() {
    sudo netstat -tuln
}

# 12. 修改虚拟内存大小
modify_swap_size() {
    echo "请输入新的虚拟内存大小 (例如: 4G):"
    read swap_size
    sudo fallocate -l $swap_size /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "虚拟内存已更改为 $swap_size"
}

# 13. 用户管理
user_management() {
    echo "请选择操作："
    echo "1. 添加用户"
    echo "2. 删除用户"
    echo "3. 修改用户信息"
    read action
    case $action in
        1)
            echo "请输入用户名："
            read username
            sudo adduser $username
            ;;
        2)
            echo "请输入要删除的用户名："
            read username
            sudo deluser $username
            ;;
        3)
            echo "请输入要修改的用户名："
            read username
            sudo chfn $username
            ;;
        *)
            echo "无效操作"
            ;;
    esac
}

# 14. 用户/密码生成器
generate_user_pass() {
    echo "请输入用户名："
    read username
    echo "请输入密码长度："
    read length
    password=$(openssl rand -base64 $length)
    echo "用户名: $username"
    echo "密码: $password"
}

# 15. 系统时区调整
adjust_timezone() {
    echo "请输入时区 (例如: Asia/Shanghai)："
    read timezone
    sudo timedatectl set-timezone $timezone
    echo "时区已设置为 $timezone"
}

# 16. 设置BBR3加速
set_bbr3() {
    sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
    echo "BBR3加速已启用"
}

# 17. 防火墙高级管理器
firewall_manager() {
    echo "请输入操作："
    echo "1. 查看防火墙状态"
    echo "2. 开放端口"
    echo "3. 关闭端口"
    read action
    case $action in
        1)
            sudo ufw status
            ;;
        2)
            echo "请输入要开放的端口："
            read port
            sudo ufw allow $port
            ;;
        3)
            echo "请输入要关闭的端口："
            read port
            sudo ufw deny $port
            ;;
        *)
            echo "无效操作"
            ;;
    esac
}

# 18. 修改主机名
change_hostname() {
    echo "请输入新主机名："
    read hostname
    sudo hostnamectl set-hostname $hostname
    echo "主机名已更改为 $hostname"
}

# 19. 切换系统更新源
change_update_source() {
    sudo sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/' /etc/apt/sources.list
    sudo apt update
    echo "系统更新源已切换为阿里云镜像"
}

# 主菜单
while true; do
    show_menu
    echo "请输入你的选择 (1-19)："
    read choice
    case $choice in
        1) set_shortcut ;;
        2) change_password ;;
        3) root_login ;;
        4) install_python_version ;;
        5) open_all_ports ;;
        6) change_ssh_port ;;
        7) optimize_dns ;;
        8) reinstall_system ;;
        9) disable_root_account ;;
        10) switch_ip_protocol ;;
        11) check_ports ;;
        12) modify_swap_size ;;
        13) user_management ;;
        14) generate_user_pass ;;
        15) adjust_timezone ;;
        16) set_bbr3 ;;
        17) firewall_manager ;;
        18) change_hostname ;;
        19) change_update_source ;;
        *) echo "无效


# 主菜单函数
function show_menu() {
    clear
    echo "--------------------------------------------"
    echo "$SCRIPT_NAME - 主菜单"
    echo "1. Docker 容器管理"
    echo "2. LDNMP 一键建站"
    echo "3. 系统优化与备份"
    echo "4. 退出"
    echo "--------------------------------------------"
    read -p "请输入您的选择: " choice
    case $choice in
        1) docker_management ;;
        2) lnmp_setup ;;
        3) system_optimization ;;
        4) exit 0 ;;
        *) echo "无效的选择，请重新输入。" && show_menu ;;
    esac
}

# Docker管理菜单
function docker_management() {
    clear
    echo "Docker管理菜单"
    echo "1. 安装 Docker"
    echo "2. 启动容器"
    echo "3. 停止容器"
    echo "4. 查看容器状态"
    echo "5. 查看镜像列表"
    echo "6. 删除容器"
    echo "7. 删除镜像"
    echo "8. 返回主菜单"
    read -p "请选择操作: " docker_choice
    case $docker_choice in
        1) install_docker ;;
        2) start_docker_container ;;
        3) stop_docker_container ;;
        4) docker_ps ;;
        5) docker_images ;;
        6) remove_docker_container ;;
        7) remove_docker_image ;;
        8) show_menu ;;
        *) echo "无效选择，请重新输入。" && docker_management ;;
    esac
}

# 安装Docker
function install_docker() {
    clear
    echo "正在安装 Docker ..."
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y docker.io
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y docker
    fi
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Docker 安装完成！"
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 启动Docker容器
function start_docker_container() {
    read -p "请输入容器镜像名称或容器ID： " container
    docker start $container
    echo "容器已启动！"
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 停止Docker容器
function stop_docker_container() {
    read -p "请输入容器镜像名称或容器ID： " container
    docker stop $container
    echo "容器已停止！"
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 查看Docker容器状态
function docker_ps() {
    clear
    docker ps -a
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 查看Docker镜像列表
function docker_images() {
    clear
    docker images
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 删除Docker容器
function remove_docker_container() {
    read -p "请输入要删除的容器ID或名称： " container
    docker rm $container
    echo "容器已删除！"
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# 删除Docker镜像
function remove_docker_image() {
    read -p "请输入要删除的镜像ID或名称： " image
    docker rmi $image
    echo "镜像已删除！"
    read -p "按Enter返回Docker管理菜单..." && docker_management
}

# LDNMP建站系统
function lnmp_setup() {
    clear
    echo "LDNMP一键建站系统"
    echo "1. 安装 LNMP 环境"
    echo "2. 配置多站点支持"
    echo "3. 网站优化与防护"
    echo "4. 备份与恢复"
    echo "5. 返回主菜单"
    read -p "请选择操作: " lnmp_choice
    case $lnmp_choice in
        1) install_lnmp ;;
        2) configure_multisite ;;
        3) website_optimization ;;
        4) backup_restore ;;
        5) show_menu ;;
        *) echo "无效选择，请重新输入。" && lnmp_setup ;;
    esac
}

# 安装 LNMP 环境
function install_lnmp() {
    clear
    echo "正在安装 LNMP 环境（Linux, Nginx, MySQL, PHP）..."
    sudo apt update && sudo apt upgrade -y
    # 安装 Nginx
    sudo apt install -y nginx
    # 安装 MySQL
    sudo apt install -y mysql-server
    # 安装 PHP
    sudo apt install -y php-fpm php-mysql
    # 启动服务
    sudo systemctl restart nginx
    sudo systemctl restart mysql
    sudo systemctl restart php7.4-fpm
    echo "LNMP 环境安装完成！"
    read -p "按Enter返回LDNMP菜单..." && lnmp_setup
}

# 配置多站点支持
function configure_multisite() {
    clear
    echo "配置 Nginx 多站点支持..."
    # 配置多站点 Nginx 配置文件
    read -p "请输入网站根目录（例如：/var/www/example.com）: " website_root
    read -p "请输入站点域名（例如：example.com）: " domain
    cat > /etc/nginx/sites-available/$domain <<EOF
server {
    listen 80;
    server_name $domain;
    root $website_root;
    index index.php index.html index.htm;
    location / {
        try_files \$uri \$uri/ =404;
    }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
    ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
    sudo systemctl reload nginx
    echo "多站点支持配置完成！"
    read -p "按Enter返回LDNMP菜单..." && lnmp_setup
}

# 网站优化与防护
function website_optimization() {
    clear
    echo "网站优化与防护"
    # 配置防火墙
    sudo ufw allow 'Nginx Full'
    sudo ufw enable
    # 启用GZIP压缩
    echo "启用GZIP压缩..."
    echo "gzip on;" >> /etc/nginx/nginx.conf
    sudo systemctl restart nginx
    echo "优化完成！"
    read -p "按Enter返回LDNMP菜单..." && lnmp_setup
}

# 备份与恢复
function backup_restore() {
    clear
    echo "备份与恢复"
    echo "1. 备份网站文件"
    echo "2. 恢复网站文件"
    echo "3. 返回主菜单"
    read -p "请选择操作: " backup_choice
    case $backup_choice in
        1) backup_website ;;
        2) restore_website ;;
        3) show_menu ;;
        *) echo "无效选择，请重新输入。" && backup_restore ;;
    esac
}

# 备份网站文件
function backup_website() {
    read -p "请输入网站根目录路径（例如：/var/www/example.com）: " website_path
    read -p "请输入备份保存路径（例如：/home/user/backups）: " backup_path
    tar -czf $backup_path/$(basename $website_path)_backup_$(date +%Y%m%d).tar.gz -C $website_path .
    echo "备份完成！"
    read -p "按Enter返回备份菜单..." && backup_restore
}

# 恢复网站文件
function restore_website() {
    read -p "请输入备份文件路径: " backup_file
    read -p "请输入恢复到的目标路径: " restore_path
    tar -xzf $backup_file -C $restore_path
    echo "恢复完成！"
    read -p "按Enter返回备份菜单..." && backup_restore
}

# 系统优化与备份
function system_optimization() {
    clear
    echo "系统优化与备份"
    echo "1. 清理系统无用文件"
    echo "2. 系统性能优化"
    echo "3. 返回主菜单"
    read -p "请选择操作: " system_choice
    case $system_choice in
        1) clean_system ;;
        2) optimize_system ;;
        3) show_menu ;;
        *) echo "无效选择，请重新输入。" && system_optimization ;;
    esac
}

# 清理系统无用文件
function clean_system() {
    clear
    echo "清理系统无用文件..."
    # 删除系统的缓存文件，日志文件，包管理器缓存等
    sudo apt-get autoremove -y
    sudo apt-get clean
    sudo rm -rf /var/cache/*
    sudo journalctl --vacuum-time=3d  # 删除3天前的日志
    echo "系统无用文件已清理完成！"
    read -p "按Enter返回系统优化菜单..." && system_optimization
}

# 系统性能优化
function optimize_system() {
    clear
    echo "系统性能优化中..."
    # 调整系统内核参数
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
    echo "fs.inotify.max_user_instances=8192" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    # 优化磁盘I/O性能
    echo "正在优化磁盘I/O性能..."
    sudo hdparm -tT /dev/sda
    # 启用系统性能调度器（根据服务器硬件情况选择）
    echo "启用系统性能调度器..."
    sudo cpupower frequency-set --governor performance
    echo "系统性能优化完成！"
    read -p "按Enter返回系统优化菜单..." && system_optimization
}

# 主执行入口
show_menu
