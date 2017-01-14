From: Daniel Borkmann <daniel@iogearbox.net>
Subject: warning in crypto_wait_for_test+0x84/0x88
Date: Sat, 14 Jan 2017 01:18:47 +0100
Message-ID: <58796E67.9070901@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: schwidefsky@de.ibm.com, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53563 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdANASx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 19:18:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

while booting a latest -net.git kernel on s390x test machine, I've hit this one
below, just in case it was not reported yet:

[...]
[    3.317031] qeth 0.0.1000: Outbound TSO not supported on eth0
[    3.317123] qeth 0.0.1000: MAC address 02:a1:11:0e:bf:f0 successfully registered on device eth0
[    3.317127] qeth 0.0.1000: Device is a Virtual NIC QDIO card (level: V633)
with link type Virt.NIC QDIO.
[    3.364637] qeth 0.0.1000 enccw0.0.1000: renamed from eth0
[    3.374169] Adding 501740k swap on /dev/dasda3.  Priority:-1 extents:1 across:501740k SSFS
[    3.436378] EXT4-fs (dasdb1): mounted filesystem with ordered data mode. Opts: (null)
[    3.459612] EXT4-fs (dasda1): mounted filesystem with ordered data mode. Opts: (null)
[   36.777259] random: crng init done
[  123.421672] device-mapper: uevent: version 1.0.3
[  123.421747] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[  124.163728] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  184.741563] ------------[ cut here ]------------
[  184.741579] WARNING: CPU: 1 PID: 537 at crypto/algapi.c:348 crypto_wait_for_test+0x84/0x88
[  184.741581] Modules linked in: ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter dm_mirror dm_region_hash dm_log dm_mod xts gf128mul aes_s390(+) des_s390 des_generic sha512_s390 qeth_l2 vmur nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache dasd_eckd_mod dasd_mod qeth ccwgroup qdio
[  184.741598] CPU: 1 PID: 537 Comm: systemd-udevd Not tainted 4.10.0-rc3+ #4
[  184.741601] Hardware name: IBM              2964 NE1              716              (z/VM)
[  184.741605] task: 00000000f544e200 task.stack: 00000000f419c000
[  184.741608] Krnl PSW : 0704f00180000000 00000000003cc484 (crypto_wait_for_test+0x84/0x88)
[  184.741613]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 RI:0 EA:3
[  184.741616] Krnl GPRS: 0000000000058e00 00000000fffffe00 ffffffff00000001 0000000000000001
[  184.741619]            00000000006863e0 00000000f3f00800 0000000000000000 000003ff80460850
[  184.741633]            000003ff80460650 000003ff80460618 000003ff80460980 00000000f419fe88
[  184.741634]            0000000000000000 00000000f4e40c00 00000000003cc45a 00000000f419fb60
[  184.741644] Krnl Code: 00000000003cc476: f073a7f40001	srp	2036(8,%r10),1,3
            00000000003cc47c: a7f4fff6		brc	15,3cc468
           #00000000003cc480: a7f40001		brc	15,3cc482
           >00000000003cc484: a7f4fff2		brc	15,3cc468
            00000000003cc488: ebdff0800024	stmg	%r13,%r15,128(%r15)
            00000000003cc48e: a7f13fc0		tmll	%r15,16320
            00000000003cc492: b90400ef		lgr	%r14,%r15
            00000000003cc496: e3f0ffd0ff71	lay	%r15,-48(%r15)
[  184.741658] Call Trace:
[  184.741659] ([<00000000003cc45a>] crypto_wait_for_test+0x5a/0x88)
[  184.741661]  [<00000000003cc7ee>] crypto_register_alg+0x76/0x88
[  184.741712]  [<000003ff8045e490>] aes_s390_register_alg+0x28/0xb98 [aes_s390]
[  184.741722]  [<000003ff80463116>] cpu_feature_match_MSA_init+0x116/0x1000 [aes_s390]
[  184.741724]  [<0000000000100276>] do_one_initcall+0x46/0x148
[  184.741729]  [<000000000024e264>] do_init_module+0x74/0x218
[  184.741735]  [<00000000001cc586>] load_module+0x141e/0x1888
[  184.741737]  [<00000000001ccbd0>] SyS_finit_module+0x98/0xd0
[  184.741741]  [<000000000068a1e6>] system_call+0xd6/0x25c
[  184.741742] Last Breaking-Event-Address:
[  184.741743]  [<00000000003cc480>] crypto_wait_for_test+0x80/0x88
[  184.741744] ---[ end trace bf4d899231b60bca ]---
[  184.741765] ------------[ cut here ]------------
[  184.741767] WARNING: CPU: 1 PID: 537 at crypto/algapi.c:342 crypto_wait_for_test+0x7c/0x88
[  184.741768] Modules linked in: ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter dm_mirror dm_region_hash dm_log dm_mod xts gf128mul aes_s390(+) des_s390 des_generic sha512_s390 qeth_l2 vmur nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache dasd_eckd_mod dasd_mod qeth ccwgroup qdio
[  184.741775] CPU: 1 PID: 537 Comm: systemd-udevd Tainted: G        W       4.10.0-rc3+ #4
[  184.741776] Hardware name: IBM              2964 NE1              716              (z/VM)
[  184.741777] task: 00000000f544e200 task.stack: 00000000f419c000
[  184.741778] Krnl PSW : 0704c00180000000 00000000003cc47c (crypto_wait_for_test+0x7c/0x88)
[  184.741780]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  184.741781] Krnl GPRS: 0000000000000001 0000000000008001 0000000000000001 0000000000000002
[  184.741783]            00000000003cc432 000000000000115e 0000000000000000 000003ff80460850
[  184.741784]            000003ff80460650 000003ff80460618 000003ff80460980 00000000f419fe88
[  184.741785]            0000000000000000 00000000f6f3d000 00000000003cc432 00000000f419fb60
[  184.741788] Krnl Code: 00000000003cc46c: ebdff0a00004	lmg	%r13,%r15,160(%r15)
            00000000003cc472: c0f4fffff073	brcl	15,3ca558
           #00000000003cc478: a7f40001		brc	15,3cc47a
           >00000000003cc47c: a7f4fff6		brc	15,3cc468
            00000000003cc480: a7f40001		brc	15,3cc482
            00000000003cc484: a7f4fff2		brc	15,3cc468
            00000000003cc488: ebdff0800024	stmg	%r13,%r15,128(%r15)
            00000000003cc48e: a7f13fc0		tmll	%r15,16320
[  184.741799] Call Trace:
[  184.741801] ([<00000000003cc432>] crypto_wait_for_test+0x32/0x88)
[  184.741803]  [<00000000003cc7ee>] crypto_register_alg+0x76/0x88
[  184.741811]  [<000003ff8045e490>] aes_s390_register_alg+0x28/0xb98 [aes_s390]
[  184.741819]  [<000003ff8046316a>] cpu_feature_match_MSA_init+0x16a/0x1000 [aes_s390]
[  184.741820]  [<0000000000100276>] do_one_initcall+0x46/0x148
[  184.741822]  [<000000000024e264>] do_init_module+0x74/0x218
[  184.741823]  [<00000000001cc586>] load_module+0x141e/0x1888
[  184.741824]  [<00000000001ccbd0>] SyS_finit_module+0x98/0xd0
[  184.741825]  [<000000000068a1e6>] system_call+0xd6/0x25c
[  184.741826] Last Breaking-Event-Address:
[  184.741827]  [<00000000003cc478>] crypto_wait_for_test+0x78/0x88
[  184.741828] ---[ end trace bf4d899231b60bcb ]---
[  184.744229] alg: Unexpected test result for xts-aes-s390: 0
[  184.786242] loop: module loaded
[  184.994173] IPv6: ADDRCONF(NETDEV_UP): enccw0.0.1000: link is not ready
[  190.719762] nr_pdflush_threads exported in /proc is scheduled for removal
[  191.041285] ip6_tables: (C) 2000-2006 Netfilter Core Team
[...]

Thanks,
Daniel
