#!/bin/bash

apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core \
                zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev \
                libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

gem install fpm

cd /usr/src
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
tar zxf ruby-1.9.3-p0.tar.gz
wget https://raw.github.com/gist/1658360/cumulative_performance.patch
patch -p1 < ../cumulative_performance.patch
cd ruby-1.9.3-p0
time (./configure --prefix=/usr && make && make install DESTDIR=installdir)

fpm -s dir -t deb -n ruby -v 1.9.3-cp -C installdir \
    -p ruby-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
    -d "libc6 (>= 2.6)" -d "libffi5 (>= 3.0.4)" -d "libgdbm3 (>= 1.8.3)" \
    -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
     -d "libssl0.9.8 (>= 0.9.8)" -d "zlib1g (>= 1:1.2.2)" \
     usr/bin usr/lib usr/share/man usr/include
