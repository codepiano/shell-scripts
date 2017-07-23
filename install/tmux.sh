#!/usr/bin/env bash
set -e

# tmux config
tmux_version="2.5"
tmux_source_dir="tmux-${tmux_version}"
tmux_tar_filename="${tmux_source_dir}.tar.gz"

# install
sudo yum -y groupinstall "Development Tools" && \
sudo yum -y install ncurses ncurses-devel libevent libevent-devel && \
wget https://github.com/tmux/tmux/releases/download/2.5/tmux-${tmux_version}.tar.gz -O "${tmux_tar_filename}" && \
mkdir "${tmux_source_dir}" && \
tar xf "${tmux_tar_filename}" -C "${tmux_source_dir}" --strip-components=1 && \
rm "${tmux_tar_filename}" && \
cd "${tmux_source_dir}" && \
./configure --prefix=/usr && \
make && sudo make install && \
echo "安装 tmux ${tmux_version} 完成"
cd ..

# 安装插件管理
tpm_path="$HOME/.tmux/plugins"
if [ ! -d "${tpm_path}" ]; then
    echo "安装插件管理插件至 ${tpm_path}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "${tpm_path}存在，跳过安装插件管理工具 tpm"
fi

# 配置 .tmux.conf
## 备份旧文件
version=`date "+%Y-%m-%d_%H:%M:%S"`
if [ -e "$HOME/.tmux.conf" ]; then
    echo "备份 $HOME/.tmux.conf 至 $HOME/.tmux.conf.bak.${version}"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak.${version}"
fi
## 生成新文件
echo "生成新配置文件至 $HOME/.tmux.conf"
tee $HOME/.tmux.conf > /dev/null <<!
setw -g mode-keys vi
set -g pane-base-index 1
bind b set-window-option synchronize-panes
set -g @shell_mode 'emacs'
set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'             # 通用配置
set -g @plugin 'christoomey/vim-tmux-navigator'         # vim 和 tmux 之间使用相同快捷键切换窗口
set -g @plugin 'tmux-plugins/tmux-copycat'              # 增强搜索功能
set -g @plugin 'tmux-plugins/tmux-yank'                 # 增强复制功能
set -g @plugin 'tmux-plugins/tmux-sessionist'           # 管理 session 的快捷键
set -g @plugin 'tmux-plugins/tmux-open'                 # 在复制模式中快速打开文件
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'     # 按下 prefix 快捷键的时候高亮
set -g @plugin 'tmux-plugins/tmux-logging'              # 记录日志
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
!
echo '安装 tmux 插件'
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    $HOME/.tmux/plugins/tpm/bin/install_plugins
else
    echo "${tpm_path}不存在，跳过插件安装"
fi
