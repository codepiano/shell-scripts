#!/bin/bash

# 出错就退出
set -e

# vim config
vim_version="8.0.0739"
vim_source_dir="vim-${vim_version}"
vim_tar_filename="${vim_source_dir}.tar.gz"

# install
sudo yum -y groupinstall "Development Tools" && \
sudo yum -y install ncurses ncurses-devel && \
wget https://github.com/vim/vim/archive/v${vim_version}.tar.gz -O "${vim_tar_filename}" && \ 
mkdir "${vim_source_dir}" && \
tar xf "${vim_tar_filename}" -C "${vim_source_dir}" --strip-components=1 && \
rm "${vim_tar_filename}" && \
cd "${vim_source_dir}" && \
make configure && \
./configure --with-features=huge --enable-pythoninterp --enable-python3interp --enable-rubyinterp --enable-cscope --enable-fontset --with-compiledby='Nagato Yuki' && \
make && sudo make install && echo "安装 vim ${vi_version} 完成" && \
# backup vi
vi_path=`which vi` && sudo mv "${vi_path}" "${vi_path}.old" && sudo ln -snf `which vim` "${vi_path}" && echo "备份 ${vi_path} 至 ${vi_path}.old，vi 软链接至 `which vim`"
cd ..

# 安装 vim 插件管理器
vundle_path="$HOME/.vim/bundle/Vundle.vim"
if [ ! -d "${vundle_path}" ]; then
    echo "安装 vim 插件管理工具至 ${vundle_path}"
    git clone https://github.com/VundleVim/Vundle.vim.git  "${vundle_path}"
else
    echo "${vundle_path} 存在，跳过安装 Vundle"
fi

# vimrc
## 备份旧  vimrc
version=`date "+%Y-%m-%d_%H:%M:%S"`
if [ -e "$HOME/.vimrc" ]; then
    echo "备份 $HOME/.vimrc 至 $HOME/.vimrc.bak.${version}"
    mv $HOME/.vimrc $HOME/.vimrc.bak.${version}
fi

## 生成新 vimrc
echo "生成新配置文件至 $HOME/.vimrc"
tee $HOME/.vimrc > /dev/null <<!
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
Plugin 'tpope/vim-sensible'                   "通用配置
Plugin 'christoomey/vim-tmux-navigator'       "在 vim 和 tmux 之间使用相同快捷键切换窗口
Plugin 'tmux-plugins/vim-tmux'                "tmux 配置文件语法高亮
call vundle#end()            " required
filetype plugin indent on    " required
!

# 建立临时文件的存放目录
## 建立撤销文件目录
if [ ! -d "$HOME/.vim/.vim_undo" ]; then
    echo "建立 vim 生成的撤销文件目录 $HOME/.vim/.vim_undo"
    mkdir -p "$HOME/.vim/.vim_undo"
fi

## 建立交换文件目录
if [ ! -d "$HOME/.vim/.vim_swap" ]; then
    echo "建立 vim 生成的交换文件目录至 $HOME/.vim/.vim_swap"
    mkdir -p "$HOME/.vim/.vim_swap"
fi

# 安装插件
echo "开始安装 vim 插件，耐心等待安装完成"
vim +PluginInstall +qall
