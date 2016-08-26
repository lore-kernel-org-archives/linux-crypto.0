From: Stephan Mueller <smueller@chronox.de>
Subject: sha1_mb broken
Date: Fri, 26 Aug 2016 03:15:06 +0200
Message-ID: <1939675.7gNnqUbNs6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37304 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbcHZBPs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 21:15:48 -0400
Received: from positron.chronox.de (unknown [173.243.43.210])
        by mail.eperm.de (Postfix) with ESMTPA id BE8B2181A7C7
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2016 03:15:07 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I tried to execute tests with sha1_mb.

The execution simply stalls when invoking a digest operation -- i.e. the 
digest operation does not finish. After some time after invoking the hashing 
operation, the following log appears (note, the kccavs_* functions are my test 
code; that test code works perfectly well with all other hash 
implementations):

[  140.426026] INFO: rcu_sched detected stalls on CPUs/tasks:
[  140.426719] 	2-...: (1 GPs behind) idle=9c3/140000000000000/0 
softirq=2680/2707 fqs=14762 
[  140.427024] 	(detected by 0, t=60002 jiffies, g=655, c=654, q=35)
[  140.427024] Task dump for CPU 2:
[  140.427024] cavs_driver     R  running task        0   945    862 
0x00000008
[  140.427024]  ffffffff9b78d965 ffffa527b8bfa640 ffffa527bb505940 
ffffa52775c20c50
[  140.427024]  ffffa527bc300000 ffffa527b93d2a80 ffffa527bb857e00 
ffffa527bc2ffd78
[  140.427024]  ffffa527b93d2ac8 ffffa527bc2ffcc0 ffffffff9b78dfc8 
ffffa527bc2ffd70
[  140.427024] Call Trace:
[  140.427024]  [<ffffffff9b78d965>] ? __schedule+0x245/0x690
[  140.427024]  [<ffffffff9b78dfc8>] ? preempt_schedule_common+0x18/0x30
[  140.427024]  [<ffffffff9b791a68>] ? _raw_spin_lock_irq+0x28/0x30
[  140.427024]  [<ffffffff9b78ed98>] ? wait_for_completion_interruptible
+0x28/0x180
[  140.427024]  [<ffffffffc028541c>] ? sha1_mb_async_digest+0x6c/0x70 
[sha1_mb]
[  140.427024]  [<ffffffff9b3b1129>] ? crypto_ahash_op+0x29/0x70
[  140.427024]  [<ffffffffc0270148>] ? kccavs_test_ahash+0x198/0x2b0 
[kcapi_cavs]
[  140.427024]  [<ffffffffc026e20a>] ? kccavs_data_read+0xda/0x160 
[kcapi_cavs]
[  140.427024]  [<ffffffff9b370964>] ? full_proxy_read+0x54/0x90
[  140.427024]  [<ffffffff9b208088>] ? __vfs_read+0x28/0x110
[  140.427024]  [<ffffffff9b38a2c0>] ? security_file_permission+0xa0/0xc0
[  140.427024]  [<ffffffff9b20850e>] ? rw_verify_area+0x4e/0xb0
[  140.427024]  [<ffffffff9b208606>] ? vfs_read+0x96/0x130
[  140.427024]  [<ffffffff9b2099f6>] ? SyS_read+0x46/0xa0
[  140.427024]  [<ffffffff9b791cb6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8



Ciao
Stephan
