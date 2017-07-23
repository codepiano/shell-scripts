## 安装脚本

### git

git.sh 2.13.3

### vim

vim.sh 8.0.0739

#### .vimrc:

```
set mouse=v                         " 鼠标模式为可视模式
syntax on                           " 开启语法高亮
set nocompatible                    " 不兼容 vi
set directory=~/.vim_swap           " 修改 vim 生成的 swp 文件的位置
set undodir=~/.vim_undo             " 修改 vim 生成的 undo 文件的位置
set fileformats=unix,dos            " 文件格式
set fenc=utf-8                      " 设置编码
set encoding=utf-8                  " 设置编码
set backspace=2                     " 设置退格键可用
set tabstop=4                       " 设置 tab 键的宽度
set expandtab                       " tab 替换为 4 个空格
set shiftwidth=4                    " 换行时行间交错使用 4 个空格
set autoindent                      " 自动对齐
set cindent shiftwidth=4            " 自动缩进4空格
set smartindent                     " 智能自动缩进
set ai                              " 设置自动缩进
set nu                              " 显示行号
set ignorecase smartcase            " 忽略大小写检索
set hlsearch                        " 开启高亮显示结果
set incsearch                       " 开启实时搜索功能

" vundle 插件
filetype off                  " required

" 加载配置 vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'tpope/vim-sensible'                   " 通用配置
Plugin 'christoomey/vim-tmux-navigator'       " 在 vim 和 tmux 之间使用相同快捷键切换窗口
Plugin 'tmux-plugins/vim-tmux'                " tmux 配置文件语法高亮
call vundle#end()            " required
filetype plugin indent on    " required
```

#### 插件:

```
Plugin 'tpope/vim-sensible'                   " 通用配置
Plugin 'christoomey/vim-tmux-navigator'       " 在 vim 和 tmux 之间使用相同快捷键切换窗口
Plugin 'tmux-plugins/vim-tmux'                " tmux 配置文件语法高亮
```

### tmux

tmux.sh 2.5

#### .tmux.conf

```
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
```

#### 插件

```
tmux-plugins/tpm                       # 插件管理
tmux-plugins/tmux-sensible             # 通用配置
christoomey/vim-tmux-navigator         # vim 和 tmux 之间使用相同快捷键切换窗口
tmux-plugins/tmux-copycat              # 增强搜索功能
tmux-plugins/tmux-yank                 # 增强复制功能
tmux-plugins/tmux-sessionist           # 管理 session 的快捷键
tmux-plugins/tmux-open                 # 在复制模式中快速打开文件
tmux-plugins/tmux-prefix-highlight     # 按下 prefix 快捷键的时候高亮
tmux-plugins/tmux-logging              # 记录日志
```
