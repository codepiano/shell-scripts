#!/usr/bin/env bash

set -e

# git config
git_version="2.13.3"
git_source_dir="git-${git_version}"
git_tar_filename="${git_source_dir}.tar.gz"

# install
sudo yum -y groupinstall "Development Tools" && \
sudo yum -y install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel && \
wget https://github.com/git/git/archive/v${git_version}.tar.gz -O "${git_tar_filename}" && \
mkdir "${git_source_dir}" && \
tar xf "${git_tar_filename}" -C "${git_source_dir}" --strip-components=1 && \
rm "${git_tar_filename}" && \
cd "${git_source_dir}" && \
make configure && \
./configure --prefix=/usr && \
make && sudo make install && echo "安装 git ${git_version} 完成"
cd ..
