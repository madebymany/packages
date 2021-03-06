#!/bin/bash
set -e
apt-get update
apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core \
                zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev \
                libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

cd /usr/src
wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar -zxvf ruby-1.9.2-p290.tar.gz
wget https://raw.github.com/gist/1008945/4edd1e1dcc1f0db52d4816843a9d1e6b60661122/ruby-1.9.2p290.patch
cd ruby-1.9.2-p290
patch -p1 < ../ruby-1.9.2p290.patch
time (./configure --prefix=/usr && make && make install DESTDIR=installdir)

make install
/usr/bin/gem install fpm

fpm -s dir -t deb -n ruby -v 1.9.2-p290 -C installdir \
    -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
    -d "libc6 (>= 2.6)" -d "libffi5 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
    -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
    -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
    usr/bin usr/lib usr/share/man usr/include

mkdir -p ../../debs
mv *.deb ../../debs/
