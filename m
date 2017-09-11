From: christophe leroy <christophe.leroy@c-s.fr>
Subject: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Mon, 11 Sep 2017 19:07:31 +0200
Message-ID: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:16744 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbdIKRUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 13:20:50 -0400
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephan,

I'm trying to use md5sum from the latest libkcapi 0.14 and I getting a 
failure with return code -5.

What am I missing ? See strace below, splice() return -ENOKEY.

Christophe

execve("./md5sum", ["./md5sum", "kcapi.tar"], [/* 11 vars */]) = 0
brk(0)                                  = 0x10024000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/ppc823/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/ppc823", 0x7ffa2328) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls", 0x7ffa2328)      = -1 ENOENT (No such file or directory)
open("/usr/lib/ppc823/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/ppc823", 0x7ffa2328)   = -1 ENOENT (No such file or directory)
open("/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/usr/lib", {st_mode=S_IFDIR|0755, st_size=3568, ...}) = 0
open("/lib/tls/ppc823/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/ppc823", 0x7ffa2328)   = -1 ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/tls", 0x7ffa2328)          = -1 ENOENT (No such file or directory)
open("/lib/ppc823/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat64("/lib/ppc823", 0x7ffa2328)       = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\2\1\3\0\0\0\0\0\0\0\0\0\3\0\24\0\0\0\1\0\2\35\\\0\0\0004"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1797540, ...}) = 0
mmap(0xfe58000, 1661856, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xfe58000
mprotect(0xffc8000, 114688, PROT_NONE)  = 0
mmap(0xffe4000, 32768, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17c000) = 0xffe4000
mmap(0xffec000, 7072, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xffec000
close(3)                                = 0
mprotect(0xffe4000, 16384, PROT_READ)   = 0
mprotect(0x1001c000, 16384, PROT_READ)  = 0
mprotect(0x779f8000, 16384, PROT_READ)  = 0
brk(0)                                  = 0x10024000
brk(0x10048000)                         = 0x10048000
open("/proc/sys/crypto/fips_enabled", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "0\n", 1024)                    = 2
close(3)                                = 0
socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
pipe([4, 5])                            = 0
socket(PF_NETLINK, SOCK_RAW, 21)        = 6
bind(6, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(6, {sa_family=AF_NETLINK, pid=266, groups=00000000}, [12]) = 0
sendmsg(6, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\0\0\0\340\0\23\0\1\0;\232\247\0\0\0\0md5\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 224}], msg_controllen=0, msg_flags=0}, 0) = 224
recvmsg(6, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\0\0\0014\0\23\0\0\0;\232\247\0\0\1\nmd5\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096}], msg_controllen=0, msg_flags=0}, 0) = 308
close(6)                                = 0
open("kcapi.tar", O_RDONLY|O_CLOEXEC)   = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=378880, ...}) = 0
mmap(NULL, 378880, PROT_READ, MAP_SHARED, 6, 0) = 0x7795c000
accept(3, 0, NULL)                      = 7
vmsplice(5, [{"bin/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 378880}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = -1 ENOKEY (Required key not available)
write(2, "Generation of hash for file kcap"..., 50) = 50
munmap(0x7795c000, 378880)              = 0
close(6)                                = 0
close(3)                                = 0
close(7)                                = 0
close(4)                                = 0
close(5)                                = 0
exit_group(-5)                          = ?
+++ exited with 251 +++


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
