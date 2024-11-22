#!/bin/bash

# 脚本版本
VERSION="1.1"
# 脚本工具名称
SCRIPT_NAME="喵哥的Shell脚本工具"

# 欢迎信息
echo "欢迎使用 $SCRIPT_NAME V$VERSION"
echo "此工具包括Docker管理器和LDNMP建站系统，支持快速搭建和管理站点。"

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

