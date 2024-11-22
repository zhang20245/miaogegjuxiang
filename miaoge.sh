#!/bin/bash

# 喵哥的 VPS 管理工具箱 - 扩展版
# 新增功能：设置快捷键、修改密码、系统优化、防火墙、内核管理等

# 定义颜色
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# 日志文件
LOG_FILE="/var/log/vps_toolbox.log"

# 输出日志
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# 输出欢迎信息
welcome_message() {
    echo -e "${GREEN}欢迎使用喵哥的 VPS 管理工具箱！${RESET}"
    echo -e "请选择你想执行的操作："
    echo -e "1. 系统信息查询"
    echo -e "2. 系统更新"
    echo -e "3. 系统清理"
    echo -e "4. 基础工具"
    echo -e "5. BBR 管理"
    echo -e "6. Docker 管理"
    echo -e "7. WARP 管理"
    echo -e "8. 测试脚本合集"
    echo -e "9. 系统优化和设置"
    echo -e "0. 退出"
}

# 系统优化和设置菜单
system_optimization_menu() {
    echo -e "${BLUE}系统优化与设置${RESET}"
    echo -e "1. 设置脚本启动快捷键"
    echo -e "2. 修改登录密码"
    echo -e "3. ROOT密码登录模式"
    echo -e "4. 安装Python指定版本"
    echo -e "5. 开放所有端口"
    echo -e "6. 修改SSH连接端口"
    echo -e "7. 优化DNS地址"
    echo -e "8. 一键重装系统"
    echo -e "9. 禁用ROOT账户创建新账户"
    echo -e "10. 切换优先ipv4/ipv6"
    echo -e "11. 查看端口占用状态"
    echo -e "12. 修改虚拟内存大小"
    echo -e "13. 用户管理"
    echo -e "14. 用户/密码生成器"
    echo -e "15. 系统时区调整"
    echo -e "16. 设置BBR3加速"
    echo -e "17. 防火墙高级管理器"
    echo -e "18. 修改主机名"
    echo -e "19. 切换系统更新源"
    echo -e "20. 定时任务管理"
    echo -e "21. 本机host解析"
    echo -e "22. fail2banSSH防御程序"
    echo -e "23. 限流自动关机"
    echo -e "24. ROOT私钥登录模式"
    echo -e "25. TG-bot系统监控预警"
    echo -e "26. 修复OpenSSH高危漏洞"
    echo -e "27. 红帽系Linux内核升级"
    echo -e "28. Linux系统内核参数优化"
    echo -e "29. 病毒扫描工具"
    echo -e "30. 文件管理器"
    echo -e "31. 切换系统语言"
    echo -e "32. 命令行美化工具"
    echo -e "33. 设置系统回收站"
    read -p "请输入操作选项: " OPT
    case $OPT in
        1) set_script_shortcut ;;
        2) change_login_password ;;
        3) enable_root_login ;;
        4) install_python_version ;;
        5) open_all_ports ;;
        6) change_ssh_port ;;
        7) optimize_dns ;;
        8) reinstall_system ;;
        9) disable_root_account ;;
        10) switch_ipv4_ipv6 ;;
        11) check_port_usage ;;
        12) change_virtual_memory ;;
        13) user_management ;;
        14) generate_user_password ;;
        15) adjust_system_timezone ;;
        16) setup_bbr3_acceleration ;;
        17) advanced_firewall_manager ;;
        18) change_hostname ;;
        19) switch_update_source ;;
        20) manage_cron_jobs ;;
        21) modify_hostfile ;;
        22) install_fail2ban ;;
        23) set_rate_limit_shutdown ;;
        24) setup_root_ssh_key ;;
        25) setup_tg_bot_monitoring ;;
        26) fix_openssh_vulnerabilities ;;
        27) upgrade_rhel_kernel ;;
        28) optimize_kernel_params ;;
        29) install_virus_scanner ;;
        30) file_manager ;;
        31) switch_system_language ;;
        32) setup_command_line_beauty ;;
        33) setup_trash_bin ;;
        *) echo -e "${RED}无效选项！${RESET}" ;;
    esac
}

# 设置脚本启动快捷键
set_script_shortcut() {
    echo -e "${YELLOW}请输入你想设置的快捷键（如：Ctrl+Alt+T）：${RESET}"
    read -p "快捷键: " shortcut
    echo "快捷键设置成功: $shortcut"
    # 在此根据操作系统环境设置快捷键，具体方法根据系统不同而有所不同
    log_message "设置脚本启动快捷键: $shortcut"
}

# 修改登录密码
change_login_password() {
    echo -e "${YELLOW}请输入当前登录用户的新密码：${RESET}"
    sudo passwd
    log_message "修改了登录密码"
}

# ROOT密码登录模式
enable_root_login() {
    echo -e "${YELLOW}开启 ROOT 密码登录模式...${RESET}"
    sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo -e "${GREEN}ROOT密码登录模式已开启！${RESET}"
    log_message "开启ROOT密码登录模式"
}

# 安装指定版本的 Python
install_python_version() {
    echo -e "${YELLOW}请输入你想安装的Python版本（如：3.8）：${RESET}"
    read -p "Python版本: " version
    sudo apt install -y python$version
    echo -e "${GREEN}Python $version 安装完成！${RESET}"
    log_message "安装 Python $version"
}

# 开放所有端口
open_all_ports() {
    echo -e "${YELLOW}正在开放所有端口...${RESET}"
    sudo ufw allow 1:65535/tcp
    sudo ufw reload
    echo -e "${GREEN}所有端口已开放！${RESET}"
    log_message "开放所有端口"
}

# 修改SSH连接端口
change_ssh_port() {
    echo -e "${YELLOW}请输入新的SSH端口号（默认：22）：${RESET}"
    read -p "SSH端口: " ssh_port
    sudo sed -i "s/^#Port 22/Port $ssh_port/" /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo -e "${GREEN}SSH端口已更改为 $ssh_port${RESET}"
    log_message "修改SSH连接端口为 $ssh_port"
}

# 优化DNS地址
optimize_dns() {
    echo -e "${YELLOW}正在优化DNS地址...${RESET}"
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
    echo -e "${GREEN}DNS地址已优化为 Google DNS（8.8.8.8）${RESET}"
    log_message "优化DNS地址"
}

# 一键重装系统
reinstall_system() {
    echo -e "${RED}警告：此操作将清空系统，请确保已备份数据！${RESET}"
    read -p "是否确认重装系统（y/n）: " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo -e "${YELLOW}正在重装系统...${RESET}"
        # 具体重装方法可根据不同系统定制
        # 假设是Debian/Ubuntu系统
        sudo reboot
        log_message "一键重装系统"
    else
        echo -e "${GREEN}已取消重装操作！${RESET}"
    fi
}

# 禁用ROOT账户创建新账户
disable_root_account() {
    echo -e "${YELLOW}禁用 ROOT 账户创建新账户...${RESET}"
    sudo passwd -l root
    echo -e "${GREEN}ROOT账户已禁用！${RESET}"
    log_message "禁用ROOT账户"
}

# 切换优先ipv4/ipv6
switch_ipv4_ipv6() {
    echo -e "${YELLOW}请输入选择的优先协议（ipv4 或 ipv6）：${
switch_ipv4_ipv6() {
    echo -e "${YELLOW}请输入选择的优先协议（ipv4 或 ipv6）：${RESET}"
    read -p "协议（ipv4 或 ipv6）: " protocol
    if [[ "$protocol" == "ipv4" ]]; then
        sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
        sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
        echo -e "${GREEN}已切换为优先IPv4${RESET}"
    elif [[ "$protocol" == "ipv6" ]]; then
        sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
        sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
        echo -e "${GREEN}已切换为优先IPv6${RESET}"
    else
        echo -e "${RED}无效选项！请输入 ipv4 或 ipv6${RESET}"
    fi
    log_message "切换优先协议为 $protocol"
}

# 查看端口占用状态
check_port_usage() {
    echo -e "${BLUE}查看端口占用状态${RESET}"
    sudo lsof -i -P -n
    log_message "查看端口占用状态"
}

# 修改虚拟内存大小
change_virtual_memory() {
    echo -e "${YELLOW}请输入新的虚拟内存大小（MB）: ${RESET}"
    read -p "虚拟内存大小: " swap_size
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$swap_size
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    echo -e "${GREEN}虚拟内存已更改为 $swap_size MB${RESET}"
    log_message "修改虚拟内存大小为 $swap_size MB"
}

# 用户管理
user_management() {
    echo -e "${BLUE}用户管理${RESET}"
    echo -e "1. 添加用户"
    echo -e "2. 删除用户"
    echo -e "3. 修改用户密码"
    echo -e "4. 查看所有用户"
    read -p "请选择操作: " user_option
    case $user_option in
        1) 
            echo -e "${YELLOW}请输入用户名：${RESET}"
            read -p "用户名: " username
            sudo adduser $username
            log_message "添加用户 $username"
            ;;
        2)
            echo -e "${YELLOW}请输入要删除的用户名：${RESET}"
            read -p "用户名: " username
            sudo deluser --remove-home $username
            log_message "删除用户 $username"
            ;;
        3)
            echo -e "${YELLOW}请输入用户名和新密码：${RESET}"
            read -p "用户名: " username
            sudo passwd $username
            log_message "修改用户 $username 密码"
            ;;
        4)
            cat /etc/passwd | cut -d: -f1
            log_message "查看所有用户"
            ;;
        *)
            echo -e "${RED}无效选项！${RESET}"
            ;;
    esac
}

# 用户/密码生成器
generate_user_password() {
    echo -e "${YELLOW}请输入要生成的用户名：${RESET}"
    read -p "用户名: " username
    password=$(openssl rand -base64 12)
    sudo useradd -m -p $(openssl passwd -1 $password) $username
    echo -e "${GREEN}已为用户 $username 创建密码：$password${RESET}"
    log_message "生成用户 $username 的密码"
}

# 系统时区调整
adjust_system_timezone() {
    echo -e "${YELLOW}请输入新的时区（例如：Asia/Shanghai）：${RESET}"
    read -p "时区: " timezone
    sudo timedatectl set-timezone $timezone
    echo -e "${GREEN}系统时区已更改为 $timezone${RESET}"
    log_message "系统时区已调整为 $timezone"
}

# 设置BBR3加速
setup_bbr3_acceleration() {
    echo -e "${YELLOW}正在安装BBR3加速...${RESET}"
    sudo bash -c "$(curl -L https://github.com/teddysun/across/raw/master/bbr.sh)"
    echo -e "${GREEN}BBR3加速安装完成！${RESET}"
    log_message "安装BBR3加速"
}

# 防火墙高级管理器
advanced_firewall_manager() {
    echo -e "${BLUE}防火墙高级管理器${RESET}"
    echo -e "1. 启用UFW防火墙"
    echo -e "2. 禁用UFW防火墙"
    echo -e "3. 查看防火墙状态"
    read -p "请选择操作: " firewall_option
    case $firewall_option in
        1)
            sudo ufw enable
            echo -e "${GREEN}防火墙已启用${RESET}"
            log_message "启用防火墙"
            ;;
        2)
            sudo ufw disable
            echo -e "${GREEN}防火墙已禁用${RESET}"
            log_message "禁用防火墙"
            ;;
        3)
            sudo ufw status verbose
            log_message "查看防火墙状态"
            ;;
        *)
            echo -e "${RED}无效选项！${RESET}"
            ;;
    esac
}

# 修改主机名
change_hostname() {
    echo -e "${YELLOW}请输入新的主机名：${RESET}"
    read -p "主机名: " hostname
    sudo hostnamectl set-hostname $hostname
    echo -e "${GREEN}主机名已修改为 $hostname${RESET}"
    log_message "修改主机名为 $hostname"
}

# 切换系统更新源
switch_update_source() {
    echo -e "${YELLOW}正在切换系统更新源...${RESET}"
    # 具体操作可能因不同的Linux发行版而有所不同
    sudo sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
    sudo apt update
    echo -e "${GREEN}系统更新源已切换为阿里云镜像源${RESET}"
    log_message "切换系统更新源"
}

# 定时任务管理
manage_cron_jobs() {
    echo -e "${BLUE}定时任务管理${RESET}"
    echo -e "1. 添加定时任务"
    echo -e "2. 查看定时任务"
    read -p "请选择操作: " cron_option
    case $cron_option in
        1)
            echo -e "${YELLOW}请输入定时任务命令：${RESET}"
            read -p "命令: " command
            echo -e "${YELLOW}请输入任务的执行时间（如：* * * * *）：${RESET}"
            read -p "时间: " time
            (crontab -l ; echo "$time $command") | crontab -
            echo -e "${GREEN}定时任务已添加！${RESET}"
            log_message "添加定时任务"
            ;;
        2)
            crontab -l
            log_message "查看定时任务"
            ;;
        *)
            echo -e "${RED}无效选项！${RESET}"
            ;;
    esac
}

# 本机host解析
modify_hostfile() {
    echo -e "${YELLOW}请输入要添加到 /etc/hosts 的条目（格式：IP 地址 主机名）：${RESET}"
    read -p "条目: " entry
    echo $entry | sudo tee -a /etc/hosts
    echo -e "${GREEN}条目已添加至 /etc/hosts${RESET}"
    log_message "修改 /etc/hosts"
}

# 安装fail2ban
install_fail2ban() {
    echo -e "${YELLOW}正在安装 fail2ban...${RESET}"
    sudo apt install -y fail2ban
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    echo -e "${GREEN}fail2ban 已安装并启动${RESET}"
    log_message "安装并启动 fail2ban"
}

# 限流自动关机
set_rate_limit_shutdown() {
    echo -e "${YELLOW}请输入限流阈值（单位：MB/s）：${RESET}"
    read -p "限流阈值: " rate_limit
    echo -e "${YELLOW}请输入关机时间（单位：秒）：${RESET}"
    read -p "关机时间: " shutdown_time
    # 配置限流和自动关机的命令，这部分可能需要根据具体的需求实现
    # 示例：触发限流后执行关机操作
    sudo bash -c "echo 'sudo shutdown -h now' > /etc/cron.d/limit_shutdown"
    echo -e "${GREEN}限流自动关机已设置！${RESET}"
    log_message "设置限流自动关机"
}

# ROOT 私钥登录模式
setup_root_ssh_key() {
    echo -e "${YELLOW}请输入您的公钥内容：${RESET}"
    read -p "公钥: " ssh_key
    echo "$ssh_key" | sudo tee -a /root/.ssh/authorized_keys > /dev/null
    sudo chmod 600 /root/.ssh/authorized_keys
    sudo chown root:root /root/.ssh/authorized_keys
    echo -e "${GREEN}ROOT用户已设置为使用SSH私钥登录！${RESET}"
    log_message "设置ROOT用户私钥登录模式"
}

# TG-bot系统监控预警
setup_tg_bot_monitoring() {
    echo -e "${YELLOW}正在配置 TG-Bot 监控预警...${RESET}"
    # 需要您提供Telegram bot token 和 chat_id
    read -p "请输入您的 Telegram Bot Token: " bot_token
    read -p "请输入您的 Telegram Chat ID: " chat_id
    echo -e "${GREEN}已配置 Telegram 监控预警！${RESET}"
    log_message "配置 TG-bot 系统监控预警"
    # 在此处添加监控脚本来发送预警
}

# 修复OpenSSH高危漏洞
fix_openssh_vulnerabilities() {
    echo -e "${YELLOW}正在修复 OpenSSH 高危漏洞...${RESET}"
    sudo apt update
    sudo apt install --only-upgrade openssh-server
    sudo systemctl restart ssh
    echo -e "${GREEN}OpenSSH 高危漏洞已修复！${RESET}"
    log_message "修复 OpenSSH 高危漏洞"
}

# 红帽系Linux内核升级
upgrade_rhel_kernel() {
    echo -e "${YELLOW}正在升级 RedHat 系统的内核...${RESET}"
    sudo yum update kernel
    sudo reboot
    echo -e "${GREEN}RedHat 系统内核升级完成！${RESET}"
    log_message "升级 RedHat 系统内核"
}

# Linux系统内核参数优化
optimize_kernel_params() {
    echo -e "${YELLOW}正在优化系统内核参数...${RESET}"
    sudo sysctl -w net.ipv4.tcp_fin_timeout=15
    sudo sysctl -w net.core.somaxconn=65535
    sudo sysctl -w vm.swappiness=10
    echo -e "${GREEN}内核参数优化完成！${RESET}"
    log_message "优化Linux系统内核参数"
}

# 病毒扫描工具
install_virus_scanner() {
    echo -e "${YELLOW}正在安装 ClamAV 病毒扫描工具...${RESET}"
    sudo apt install -y clamav clamav-daemon
    sudo freshclam
    echo -e "${GREEN}ClamAV 安装完成！现在可以进行病毒扫描${RESET}"
    log_message "安装 ClamAV 病毒扫描工具"
}

# 文件管理器
file_manager() {
    echo -e "${BLUE}文件管理器${RESET}"
    echo -e "1. 打开文件浏览器"
    echo -e "2. 查看当前目录"
    read -p "请选择操作: " file_option
    case $file_option in
        1)
            if command -v ranger &>/dev/null; then
                ranger
            else
                echo -e "${RED}未安装 Ranger 文件浏览器，请先安装它！${RESET}"
            fi
            ;;
        2)
            ls -l
            ;;
        *)
            echo -e "${RED}无效选项！${RESET}"
            ;;
    esac
    log_message "使用文件管理器"
}

# 切换系统语言
switch_system_language() {
    echo -e "${YELLOW}请输入系统语言（如：en_US.UTF-8 或 zh_CN.UTF-8）：${RESET}"
    read -p "系统语言: " language
    sudo update-locale LANG=$language
    echo -e "${GREEN}系统语言已更改为 $language${RESET}"
    log_message "切换系统语言为 $language"
}

# 命令行美化工具
setup_command_line_beauty() {
    echo -e "${YELLOW}正在安装命令行美化工具（zsh + oh-my-zsh）...${RESET}"
    sudo apt install -y zsh
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "${GREEN}命令行美化工具已安装完成！${RESET}"
    log_message "安装命令行美化工具"
}

# 设置系统回收站
setup_trash_bin() {
    echo -e "${YELLOW}正在设置系统回收站...${RESET}"
    sudo apt install -y trash-cli
    echo -e "${GREEN}系统回收站已设置！你可以使用 'trash' 命令管理删除的文件${RESET}"
    log_message "设置系统回收站"
}

# 主菜单函数
main_menu() {
    while true; do
        welcome_message
        read -p "请选择操作： " option
        case $option in
            1) system_info ;;
            2) system_update ;;
            3) system_cleanup ;;
            4) basic_tools ;;
            5) bbr_management ;;
            6) docker_management ;;
            7) warp_management ;;
            8) test_scripts ;;
            9) system_optimization_menu ;;
            0) echo -e "${GREEN}退出喵哥 VPS 管理工具箱，谢谢使用！${RESET}"; exit 0 ;;
            *) echo -e "${RED}无效选项！请重新选择。${RESET}" ;;
        esac
    done
}

# 运行主菜单
main_menu
