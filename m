From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc64] crc32c misbehave
Date: Wed, 31 May 2017 14:56:52 +0300
Message-ID: <CADxRZqzNTB1n0g1r_2rLsjifHpJ+_x1WPxNOSqEcHbi74jHi5w@mail.gmail.com>
References: <CADxRZqzgaL4ew6PVek3WBsdwo6GcT0ORx=7h+6p0V3NAr8qF+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-crypto@vger.kernel.org
To: Sparc kernel list <sparclinux@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38069 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdEaL5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2017 07:57:00 -0400
In-Reply-To: <CADxRZqzgaL4ew6PVek3WBsdwo6GcT0ORx=7h+6p0V3NAr8qF+w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello!

While debugging occasional crc32c checksum errors with xfs disk reads on
sparc64 (T5 [sun4v] 3.6 GHz CPU ldom, debian unstable/sid), Eric have found
that crc32c sometimes returns wrong checksum for data. Eric made a simple
test kernel module (included), which produce the following results on my
sparc64 machines:

# cat test3.c
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/init.h>
#include <linux/crc32c.h>

#define CRC_SEED (~(u32)0)

static int __init mymodule_init (void)
{
char data[512];
u32 oldcrc = 0xd00dface, crc = 0xdeadbeef;
int i;
u64 nsec;

memset(data, 0, 512);

nsec = ktime_get_ns();
for (i = 0; i < 1000000; i++) {
crc = crc32c(CRC_SEED, data, 512);

if (i > 0 && crc != oldcrc)
printk("i: %d: oldcrc: 0x%x, crc: 0x%x\n", i, oldcrc, crc);
oldcrc = crc;
}
nsec = ktime_get_ns() - nsec;

printk("Loop done in %lld nsec\n", nsec);
return 0;
}

static void __exit mymodule_exit (void)
{
printk ("Module uninitialized successfully \n");
}

module_init(mymodule_init);
module_exit(mymodule_exit);
MODULE_LICENSE("GPL");


root@ttip# modprobe libcrc32c
root@ttip# for i in `seq 1 100`; do echo -n "$i "; insmod ./test3.ko; sleep
1; rmmod test3; done
# journalctl -k -f

CONFIG_CRYPTO_CRC32C = M
CONFIG_CRYPTO_CRC32C_SPARC64 = M

# lsmod| grep crc
crc32test               1557  0
libcrc32c               1382  3 nf_conntrack,xfs,nf_nat
crc32c_generic          2528  0
crc16                   1745  1 ext4
crc32c_sparc64          3493  3


May 31 12:35:13 ttip kernel: Module uninitialized successfully
May 31 12:35:13 ttip kernel: Loop done in 139269659 nsec
May 31 12:35:14 ttip kernel: Module uninitialized successfully
May 31 12:35:15 ttip kernel: Loop done in 139650571 nsec
May 31 12:35:16 ttip kernel: Module uninitialized successfully
May 31 12:35:16 ttip kernel: Loop done in 139559959 nsec
May 31 12:35:17 ttip kernel: Module uninitialized successfully
May 31 12:35:17 ttip kernel: Loop done in 139212192 nsec
May 31 12:35:18 ttip kernel: Module uninitialized successfully
May 31 12:35:18 ttip kernel: Loop done in 139619805 nsec
May 31 12:35:19 ttip kernel: Module uninitialized successfully
May 31 12:35:20 ttip kernel: Loop done in 139558722 nsec
May 31 12:35:21 ttip kernel: Module uninitialized successfully
May 31 12:35:21 ttip kernel: i: 34706: oldcrc: 0xcf03123f, crc: 0x0
May 31 12:35:21 ttip kernel: i: 34707: oldcrc: 0x0, crc: 0xcf03123f
May 31 12:35:36 ttip kernel: Module uninitialized successfully
May 31 12:35:37 ttip kernel: i: 695650: oldcrc: 0xcf03123f, crc: 0x0
May 31 12:35:37 ttip kernel: i: 695651: oldcrc: 0x0, crc: 0xcf03123f
May 31 12:36:24 ttip kernel: Module uninitialized successfully
May 31 12:36:24 ttip kernel: i: 664460: oldcrc: 0xcf03123f, crc: 0x0
May 31 12:36:24 ttip kernel: i: 664461: oldcrc: 0x0, crc: 0xcf03123f

another run with kernel
CONFIG_CRYPTO_CRC32C = M
CONFIG_CRYPTO_CRC32C_SPARC64 is not set

# lsmod | grep crc
libcrc32c               1382  3 nf_conntrack,xfs,nf_nat
crc32c_generic          2528  3
crc16                   1745  1 ext4

May 31 12:57:26 ttip kernel: test3: loading out-of-tree module taints
kernel.
May 31 12:57:26 ttip kernel: Loop done in 439555353 nsec
May 31 12:57:27 ttip kernel: Module uninitialized successfully
May 31 12:57:28 ttip kernel: Loop done in 441111064 nsec
May 31 12:57:29 ttip kernel: Module uninitialized successfully
May 31 12:57:29 ttip kernel: Loop done in 439476126 nsec
May 31 12:57:30 ttip kernel: Module uninitialized successfully
May 31 12:57:31 ttip kernel: Loop done in 440995512 nsec
May 31 12:57:32 ttip kernel: Module uninitialized successfully
May 31 12:57:33 ttip kernel: Loop done in 439825440 nsec
May 31 12:57:34 ttip kernel: Module uninitialized successfully
May 31 12:57:34 ttip kernel: i: 293384: oldcrc: 0xcf03123f, crc: 0x0
May 31 12:57:34 ttip kernel: i: 293385: oldcrc: 0x0, crc: 0xcf03123f
May 31 12:57:34 ttip kernel: Loop done in 439500110 nsec
May 31 12:57:35 ttip kernel: Module uninitialized successfully
May 31 13:02:26 ttip kernel: i: 293577: oldcrc: 0xcf03123f, crc: 0x0
May 31 13:02:26 ttip kernel: i: 293578: oldcrc: 0x0, crc: 0xcf03123f
May 31 13:02:26 ttip kernel: i: 515055: oldcrc: 0xcf03123f, crc: 0x0
May 31 13:02:26 ttip kernel: i: 515056: oldcrc: 0x0, crc: 0xcf03123f
May 31 13:03:15 ttip kernel: Module uninitialized successfully
May 31 13:03:15 ttip kernel: i: 259986: oldcrc: 0xcf03123f, crc: 0x0
May 31 13:03:15 ttip kernel: i: 259987: oldcrc: 0x0, crc: 0xcf03123f
May 31 13:03:16 ttip kernel: Loop done in 449601790 nsec


cycle loading (for i in `seq 1 100`) crc32test module
(CONFIG_CRC32_SELFTEST) shows all tests as passed (no errors).

running on older (1.5 GHz cpu) sparc64 (sun4u) v215 machine hit wrong crc
error  immidiatelly:

# lsmod | grep crc
crc16                   1591  1 ext4
libcrc32c               1234  1 raid456
crc32c_generic          2270  1

root@v215# journalctl  -k -b
May 31 14:32:13 v215 kernel: systemd: 28 output lines suppressed due to
ratelimiting
May 31 14:36:34 v215 kernel: test3: loading out-of-tree module taints
kernel.
May 31 14:36:35 v215 kernel: i: 99466: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:35 v215 kernel: i: 99467: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:35 v215 kernel: Loop done in 1017018626 nsec
May 31 14:36:36 v215 kernel: Module uninitialized successfully
May 31 14:36:37 v215 kernel: i: 320351: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:37 v215 kernel: i: 320352: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:38 v215 kernel: Loop done in 1019229670 nsec
May 31 14:36:39 v215 kernel: Module uninitialized successfully
May 31 14:36:39 v215 kernel: i: 275151: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:39 v215 kernel: i: 275152: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:40 v215 kernel: Loop done in 1019406833 nsec
May 31 14:36:41 v215 kernel: Module uninitialized successfully
May 31 14:36:41 v215 kernel: i: 356512: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:41 v215 kernel: i: 356513: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:42 v215 kernel: Loop done in 1019136933 nsec
May 31 14:36:43 v215 kernel: Module uninitialized successfully
May 31 14:36:43 v215 kernel: i: 243633: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:43 v215 kernel: i: 243634: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:44 v215 kernel: i: 409279: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:44 v215 kernel: i: 409280: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:44 v215 kernel: i: 516166: oldcrc: 0xcf03123f, crc: 0x0
May 31 14:36:44 v215 kernel: i: 516167: oldcrc: 0x0, crc: 0xcf03123f
May 31 14:36:44 v215 kernel: Loop done in 1285740619 nsec
May 31 14:36:45 v215 kernel: Module uninitialized successfully

Tested as well on x86_64 and ppc64 machines, and can't reproduce it there.

Can someone please look what is wrong with crc32c on sparc64 ?!
Thanks!
