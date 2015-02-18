From: "George Spelvin" <linux@horizon.com>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: 18 Feb 2015 01:34:34 -0500
Message-ID: <20150218063434.24444.qmail@ns.horizon.com>
References: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux@horizon.com
To: keescook@chromium.org, minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:50023 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752586AbbBRGeg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2015 01:34:36 -0500
In-Reply-To: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Could you rename and instrument your /sbin/modprobe to do something like:
>
> #!/bin/sh
> echo "$@" >> /root/modprobe.log
> exec /sbin/modprobe.bin "$@"

Thanks for the script, bit it turned out not to work... modern modprobe
is a link to kmod, and if the basename of argv[0] is not exactly
"modprobe", it doesn't DTRT.

Solved by renaming to /sbin/x/modprobe.

Anyway, modprobe.log follows (with a slightly more ambitious script that
also shows the parent processes and environment), followed by straces
of manually repeating the failing modprobe commands.

It's trying to load modules named:

crypto-ccm(aes)
crypto-ccm(aes)-all
crypto-ctr(aes)
crypto-ctr(aes)-all

depmod -n doesn't show any aliases with parens in their names,


Wed Feb 18 06:57:55 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)
My PID is 21789, PPID is 21788  -p 2 -p 6 -p 21788 -p 21789 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21788 ?        S      0:00      \_ [kworker/u4:0]
21789 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:55 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)-all
My PID is 21799, PPID is 21798  -p 2 -p 6 -p 21798 -p 21799 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21798 ?        S      0:00      \_ [kworker/u4:0]
21799 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:55 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)
My PID is 21808, PPID is 21807  -p 2 -p 6 -p 21807 -p 21808 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21807 ?        S      0:00      \_ [kworker/u4:0]
21808 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:55 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)-all
My PID is 21816, PPID is 21815  -p 2 -p 6 -p 21815 -p 21816 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21815 ?        S      0:00      \_ [kworker/u4:0]
21816 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:55 UTC 2015 /sbin/modprobe -q -- crypto-ctr
My PID is 21827, PPID is 21826  -p 2 -p 6 -p 21826 -p 21827 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21826 ?        S      0:00      \_ [kworker/u4:0]
21827 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:57 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)
My PID is 21995, PPID is 21993  -p 2 -p 6 -p 21993 -p 21995 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
21993 ?        S      0:00      \_ [kworker/u4:0]
21995 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:57 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)-all
My PID is 22006, PPID is 22005  -p 2 -p 6 -p 22005 -p 22006 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        D      0:00  \_ [kworker/u4:0]
22005 ?        S      0:00      \_ [kworker/u4:0]
22006 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:57 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)
My PID is 22020, PPID is 22019  -p 2 -p 46 -p 22019 -p 22020 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
   46 ?        S      0:00  \_ [kworker/u4:1]
22019 ?        S      0:00      \_ [kworker/u4:1]
22020 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:57 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)-all
My PID is 22029, PPID is 22028  -p 2 -p 46 -p 22028 -p 22029 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
   46 ?        S      0:00  \_ [kworker/u4:1]
22028 ?        S      0:00      \_ [kworker/u4:1]
22029 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:57:57 UTC 2015 /sbin/modprobe -q -- crypto-ctr
My PID is 22041, PPID is 22040  -p 2 -p 46 -p 22040 -p 22041 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
   46 ?        R      0:00  \_ [kworker/u4:1]
22040 ?        S      0:00      \_ [kworker/u4:1]
22041 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:00 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)
My PID is 22247, PPID is 22244  -p 2 -p 6 -p 22244 -p 22247 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
22244 ?        S      0:00      \_ [kworker/u4:0]
22247 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:00 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)-all
My PID is 22257, PPID is 22256  -p 2 -p 6 -p 22256 -p 22257 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
22256 ?        S      0:00      \_ [kworker/u4:0]
22257 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:00 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)
My PID is 22266, PPID is 22265  -p 2 -p 6 -p 22265 -p 22266 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
22265 ?        S      0:00      \_ [kworker/u4:0]
22266 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:00 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)-all
My PID is 22275, PPID is 22274  -p 2 -p 6 -p 22274 -p 22275 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        D      0:00  \_ [kworker/u4:0]
22274 ?        S      0:00      \_ [kworker/u4:0]
22275 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:00 UTC 2015 /sbin/modprobe -q -- crypto-ctr
My PID is 22287, PPID is 22286  -p 2 -p 11891 -p 22286 -p 22287 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        S      0:00  \_ [kworker/u4:2]
22286 ?        S      0:00      \_ [kworker/u4:2]
22287 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:03 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)
My PID is 22534, PPID is 22531  -p 2 -p 6 -p 22531 -p 22534 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
22531 ?        S      0:00      \_ [kworker/u4:0]
22534 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:03 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)-all
My PID is 22542, PPID is 22541  -p 2 -p 6 -p 22541 -p 22542 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
22541 ?        S      0:00      \_ [kworker/u4:0]
22542 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:03 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)
My PID is 22556, PPID is 22555  -p 2 -p 6 -p 22555 -p 22556 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        D      0:00  \_ [kworker/u4:0]
22555 ?        S      0:00      \_ [kworker/u4:0]
22556 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:03 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)-all
My PID is 22570, PPID is 22569  -p 2 -p 11891 -p 22569 -p 22570 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        S      0:00  \_ [kworker/u4:2]
22569 ?        S      0:00      \_ [kworker/u4:2]
22570 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:03 UTC 2015 /sbin/modprobe -q -- crypto-ctr
My PID is 22583, PPID is 22582  -p 2 -p 11891 -p 22582 -p 22583 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        S      0:00  \_ [kworker/u4:2]
22582 ?        S      0:00      \_ [kworker/u4:2]
22583 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)
My PID is 23162, PPID is 23159  -p 2 -p 11891 -p 23159 -p 23162 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        S      0:00  \_ [kworker/u4:2]
23159 ?        S      0:00      \_ [kworker/u4:2]
23162 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ccm(aes)-all
My PID is 23171, PPID is 23169  -p 2 -p 11891 -p 23169 -p 23171 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        S      0:00  \_ [kworker/u4:2]
23169 ?        S      0:00      \_ [kworker/u4:2]
23171 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ccm(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)
My PID is 23184, PPID is 23181  -p 2 -p 11891 -p 23181 -p 23184 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
11891 ?        D      0:00  \_ [kworker/u4:2]
23181 ?        S      0:00      \_ [kworker/u4:2]
23184 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes) HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ctr(aes)-all
My PID is 23194, PPID is 23193  -p 2 -p 6 -p 23193 -p 23194 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
23193 ?        S      0:00      \_ [kworker/u4:0]
23194 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr(aes)-all HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin

Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ctr
My PID is 23203, PPID is 23202  -p 2 -p 6 -p 23202 -p 23203 
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    6 ?        S      0:00  \_ [kworker/u4:0]
23202 ?        S      0:00      \_ [kworker/u4:0]
23203 ?        S      0:00          \_ /bin/bash /sbin/modprobe -q -- crypto-ctr HOME=/ TERM=linux PATH=/sbin:/usr/sbin:/bin:/usr/bin


execve("/sbin/x/modprobe", ["/sbin/x/modprobe", "-v", "crypto_ccm(aes)"], [/* 15 vars */]) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
stat64("/etc/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/etc/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "oss-compat.conf", {st_mode=S_IFREG|0644, st_size=119, ...}, 0) = 0
fstatat64(3, "fbdev-blacklist.conf", {st_mode=S_IFREG|0644, st_size=390, ...}, 0) = 0
fstatat64(3, "i915-kms.conf", {st_mode=S_IFREG|0644, st_size=23, ...}, 0) = 0
fstatat64(3, "etc-modules-parameters.conf", {st_mode=S_IFREG|0644, st_size=75, ...}, 0) = 0
fstatat64(3, "libpisock9.conf", {st_mode=S_IFREG|0644, st_size=16, ...}, 0) = 0
fstatat64(3, "local.conf", {st_mode=S_IFREG|0644, st_size=453, ...}, 0) = 0
stat64("/run/modprobe.d", 0xbf948aac)   = -1 ENOENT (No such file or directory)
stat64("/lib/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/lib/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "aliases.conf", {st_mode=S_IFREG|0644, st_size=655, ...}, 0) = 0
open("/lib/modprobe.d/aliases.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/etc-modules-parameters.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/fbdev-blacklist.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/i915-kms.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/libpisock9.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/local.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.softdep", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/oss-compat.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/proc/cmdline", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.dep.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.alias.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.symbols.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.builtin.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/sys/module/crypto_ccm(aes)/initstate", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/sys/module/crypto_ccm(aes)", 0xbf948adc) = -1 ENOENT (No such file or directory)
write(2, "modprobe: FATAL: Module crypto_ccm(aes) not found.\n", 51) = 51
+++ exited with 1 +++

execve("/sbin/x/modprobe", ["/sbin/x/modprobe", "-v", "crypto_ccm(aes)_all"], [/* 15 vars */]) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
stat64("/etc/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/etc/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "oss-compat.conf", {st_mode=S_IFREG|0644, st_size=119, ...}, 0) = 0
fstatat64(3, "fbdev-blacklist.conf", {st_mode=S_IFREG|0644, st_size=390, ...}, 0) = 0
fstatat64(3, "i915-kms.conf", {st_mode=S_IFREG|0644, st_size=23, ...}, 0) = 0
fstatat64(3, "etc-modules-parameters.conf", {st_mode=S_IFREG|0644, st_size=75, ...}, 0) = 0
fstatat64(3, "libpisock9.conf", {st_mode=S_IFREG|0644, st_size=16, ...}, 0) = 0
fstatat64(3, "local.conf", {st_mode=S_IFREG|0644, st_size=453, ...}, 0) = 0
stat64("/run/modprobe.d", 0xbfb8e2ac)   = -1 ENOENT (No such file or directory)
stat64("/lib/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/lib/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "aliases.conf", {st_mode=S_IFREG|0644, st_size=655, ...}, 0) = 0
open("/lib/modprobe.d/aliases.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/etc-modules-parameters.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/fbdev-blacklist.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/i915-kms.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/libpisock9.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/local.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.softdep", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/oss-compat.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/proc/cmdline", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.dep.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.alias.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.symbols.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.builtin.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/sys/module/crypto_ccm(aes)_all/initstate", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/sys/module/crypto_ccm(aes)_all", 0xbfb8e2dc) = -1 ENOENT (No such file or directory)
write(2, "modprobe: FATAL: Module crypto_ccm(aes)_all not found.\n", 55) = 55
+++ exited with 1 +++

execve("/sbin/x/modprobe", ["/sbin/x/modprobe", "-v", "crypto_ctr(aes)"], [/* 15 vars */]) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
stat64("/etc/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/etc/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "oss-compat.conf", {st_mode=S_IFREG|0644, st_size=119, ...}, 0) = 0
fstatat64(3, "fbdev-blacklist.conf", {st_mode=S_IFREG|0644, st_size=390, ...}, 0) = 0
fstatat64(3, "i915-kms.conf", {st_mode=S_IFREG|0644, st_size=23, ...}, 0) = 0
fstatat64(3, "etc-modules-parameters.conf", {st_mode=S_IFREG|0644, st_size=75, ...}, 0) = 0
fstatat64(3, "libpisock9.conf", {st_mode=S_IFREG|0644, st_size=16, ...}, 0) = 0
fstatat64(3, "local.conf", {st_mode=S_IFREG|0644, st_size=453, ...}, 0) = 0
stat64("/run/modprobe.d", 0xbffb1b7c)   = -1 ENOENT (No such file or directory)
stat64("/lib/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/lib/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "aliases.conf", {st_mode=S_IFREG|0644, st_size=655, ...}, 0) = 0
open("/lib/modprobe.d/aliases.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/etc-modules-parameters.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/fbdev-blacklist.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/i915-kms.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/libpisock9.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/local.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.softdep", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/oss-compat.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/proc/cmdline", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.dep.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.alias.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.symbols.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.builtin.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/sys/module/crypto_ctr(aes)/initstate", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/sys/module/crypto_ctr(aes)", 0xbffb1bac) = -1 ENOENT (No such file or directory)
write(2, "modprobe: FATAL: Module crypto_ctr(aes) not found.\n", 51) = 51
+++ exited with 1 +++

execve("/sbin/x/modprobe", ["/sbin/x/modprobe", "-v", "crypto_ctr(aes)_all"], [/* 15 vars */]) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
stat64("/etc/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/etc/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "oss-compat.conf", {st_mode=S_IFREG|0644, st_size=119, ...}, 0) = 0
fstatat64(3, "fbdev-blacklist.conf", {st_mode=S_IFREG|0644, st_size=390, ...}, 0) = 0
fstatat64(3, "i915-kms.conf", {st_mode=S_IFREG|0644, st_size=23, ...}, 0) = 0
fstatat64(3, "etc-modules-parameters.conf", {st_mode=S_IFREG|0644, st_size=75, ...}, 0) = 0
fstatat64(3, "libpisock9.conf", {st_mode=S_IFREG|0644, st_size=16, ...}, 0) = 0
fstatat64(3, "local.conf", {st_mode=S_IFREG|0644, st_size=453, ...}, 0) = 0
stat64("/run/modprobe.d", 0xbfba17dc)   = -1 ENOENT (No such file or directory)
stat64("/lib/modprobe.d", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/lib/modprobe.d", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstatat64(3, "aliases.conf", {st_mode=S_IFREG|0644, st_size=655, ...}, 0) = 0
open("/lib/modprobe.d/aliases.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/etc-modules-parameters.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/fbdev-blacklist.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/i915-kms.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/libpisock9.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/local.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.softdep", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/etc/modprobe.d/oss-compat.conf", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/proc/cmdline", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.dep.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.alias.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.symbols.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/lib/modules/3.19.0-00008-g95bebed/modules.builtin.bin", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
open("/sys/module/crypto_ctr(aes)_all/initstate", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/sys/module/crypto_ctr(aes)_all", 0xbfba180c) = -1 ENOENT (No such file or directory)
write(2, "modprobe: FATAL: Module crypto_ctr(aes)_all not found.\n", 55) = 55
+++ exited with 1 +++
