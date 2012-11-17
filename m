From: Guru Shetty <gurushettylists@gmail.com>
Subject: crypto: Kernel crashes at crypto_alg_mod_lookup
Date: Sat, 17 Nov 2012 15:19:52 -0800
Message-ID: <CANR7ExJ1bjf7X_Lhn_UBKrq10C0g3T9E6Fdpp52wjxav532rZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KQXTw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2012 18:19:52 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so2607526pad.19
        for <linux-crypto@vger.kernel.org>; Sat, 17 Nov 2012 15:19:52 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello All,
  I see kernel crashes in some of my x86_64 machines only during the
system boot up.
Specifically, it happens when one of the strongswan daemons is started.
I have seen it quite a few times in Linux 3.2 stable branch. I do not
have a good reproduction scenario yet.

The kernel backtrace is as follows.
CPU 5
[   69.435004] Modules linked in: openvswitch(O) seqiv algif_skcipher
md4 algif_hash af_alg aesni_intel
 cryptd aes_x86_64 xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp
esp4 ah4 deflate ctr twofish_gener
ic twofish_x86_64_3way twofish_x86_64 twofish_common camellia serpent
blowfish_generic blowfish_x86_64
blowfish_common cast5 des_generic xcbc rmd160 sha512_generic
crypto_null af_key psmouse ioatdma i7core_
edac serio_raw edac_core lp dca mac_hid parport usbhid hid bnx2x btrfs
e1000e megaraid_sas mdio zlib_de
flate libcrc32c
[   69.436890]
[   69.436927] Pid: 1293, comm: pluto Tainted: G           O 3.2.30+
#5 iXsystems iX22X4-TTH6RF/X8DTT-H
[   69.437076] RIP: 0010:[<ffffffff812d568f>]  [<ffffffff812d568f>]
crypto_larval_kill+0x2f/0x90
[   69.437163] RSP: 0018:ffff880be4033c38  EFLAGS: 00010292
[   69.437206] RAX: dead000000200200 RBX: ffff880be3c93e00 RCX: 0000000000000159
[   69.437252] RDX: ffff880be3c90a00 RSI: 0000000000016660 RDI: ffffffff81c62ec0
[   69.437298] RBP: ffff880be4033c48 R08: ffffea002f8f2400 R09: ffffffff812d5c20
[   69.437344] R10: 0000000000000000 R11: 0000000000000001 R12: fffffffffffffffe
[   69.437390] R13: 0000000000000004 R14: ffff880be4033cd0 R15: ffff880be461dbc0
[   69.437437] FS:  00007f1e97beb700(0000) GS:ffff880c0fca0000(0000)
knlGS:0000000000000000
[   69.437499] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.437557] CR2: 00007fab55f7e120 CR3: 0000000be46d8000 CR4: 00000000000006e0
[   69.437616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.437676] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.437736] Process pluto (pid: 1293, threadinfo ffff880be4032000,
task ffff880be461dbc0)
[   69.437811] Stack:
[   69.437861]  ffff880be3c93e00 fffffffffffffffe ffff880be4033c68
ffffffff812d5eeb
[   69.438067]  0000000000000000 000000000000020c ffff880be4033cb8
ffffffff812d5f81
[   69.438271]  ffff880be4033cc8 ffff880be4033c88 dead000000100100
0000000000000000
[   69.438477] Call Trace:
[   69.438531]  [<ffffffff812d5eeb>] crypto_alg_mod_lookup+0x6b/0x90
[   69.438590]  [<ffffffff812d5f81>] crypto_alloc_base+0x41/0xb0
[   69.438651]  [<ffffffffa02a8a58>] cryptd_alloc_ablkcipher+0x88/0xc0 [cryptd]
[   69.438712]  [<ffffffff812d5802>] ? __crypto_alloc_tfm+0x52/0x160
[   69.438773]  [<ffffffffa02b84c1>] ablk_rfc3686_ctr_init+0x21/0x40
[aesni_intel]
[   69.438848]  [<ffffffff812d5879>] __crypto_alloc_tfm+0xc9/0x160
[   69.438907]  [<ffffffff812d6fac>] crypto_spawn_tfm+0x4c/0x90
[   69.438966]  [<ffffffff8115df3c>] ? __kmalloc+0x12c/0x190
[   69.439025]  [<ffffffff812da33b>] skcipher_geniv_init+0x2b/0x50
[   69.439083]  [<ffffffffa02d605c>] seqiv_init+0x1c/0x20 [seqiv]
[   69.439142]  [<ffffffff812d5879>] __crypto_alloc_tfm+0xc9/0x160
[   69.439201]  [<ffffffff812d97eb>] crypto_alloc_ablkcipher+0x6b/0xc0
[   69.439261]  [<ffffffffa02d036e>] skcipher_bind+0xe/0x10 [algif_skcipher]
[   69.439322]  [<ffffffffa02c6426>] alg_bind+0x76/0x130 [af_alg]
[   69.439382]  [<ffffffff8151d1c4>] sys_bind+0xe4/0x100
[   69.439439]  [<ffffffff8151cee0>] ? sys_socket+0x40/0x70
[   69.439498]  [<ffffffff81644c82>] system_call_fastpath+0x16/0x1b
[   69.439556] Code: 53 48 83 ec 08 66 66 66 66 90 48 89 fb 48 c7 c7
c0 2e c6 81 e8 33 67 36 00 48 8b 13 48 8b 43 08 48 c7 c7 c0 2e c6 81
48 89 42 08 <48> 89 10 48 b8 00 01 10 00 00 00 ad de 48 ba 00 02 20 00
00 00

The kernel backtrace is not always the same. But crypto_alg_mod_lookup
is common across different back traces.
Can someone please shed some light on where the problem could be? I
can try and reproduce
and provide more information, if I get some context on why it happens
only during system startup.

Thanks,
Guru.
