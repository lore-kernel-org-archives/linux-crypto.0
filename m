From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 07 Oct 2017 14:56:24 +0200
Message-ID: <12183583.FhH6M9YiZ5@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <4036185.N3O6K43VGH@positron.chronox.de> <20171007032948.GA29578@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34730 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbdJGM43 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 08:56:29 -0400
In-Reply-To: <20171007032948.GA29578@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 7. Oktober 2017, 05:29:48 CEST schrieb Herbert Xu:

Hi Herbert,

> I see the problem now.  This was introduced with the skcipher walk
> interface.  The blkcipher walk interface didn't have this issue.
> 
> I guess we should add a zero test vector once this is fixed.

Thank you.

This fixes the issue. 

Tested-by: Stephan Müller <smueller@chronox.de>

Though, this opens up the shash issue I tried to fix.

[  213.090857] ------------[ cut here ]------------
[  213.091318] kernel BUG at ./include/linux/scatterlist.h:123!
[  213.091986] invalid opcode: 0000 [#1] SMP
[  213.092307] Modules linked in: algif_skcipher crypto_user authenc 
algif_aead af_alg ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_mangle 
ip6table_raw ip6table_security iptable_mangle iptable_raw iptable_security 
ebtable_filter ebtables ip6table_filter ip6_tables crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel virtio_balloon virtio_net pcspkr i2c_piix4 
sch_fq_codel virtio_blk virtio_console crc32c_intel virtio_pci virtio_ring 
serio_raw virtio
[  213.092307] CPU: 0 PID: 1014 Comm: kcapi Not tainted 4.14.0-rc1+ #555
[  213.092307] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.10.2-1.fc26 04/01/2014
[  213.092307] task: ffff8b8838e94f80 task.stack: ffff9dbe40598000
[  213.092307] RIP: 0010:shash_ahash_digest+0xc9/0xd0
[  213.092307] RSP: 0018:ffff9dbe4059bc38 EFLAGS: 00010286
[  213.092307] RAX: 0000000087654321 RBX: ffff8b883bf64cb8 RCX: 
ffff8b883bf64810
[  213.092307] RDX: 0000000000000000 RSI: ffff8b883bf64d08 RDI: 
000000003bf64858
[  213.092307] RBP: ffff9dbe4059bc58 R08: ffffffff99402320 R09: 
ffff9dbe4059bd70
[  213.092307] R10: ffff9dbe4059bcb8 R11: ffff8b883bf64810 R12: 
ffff8b883bf64d08
[  213.092307] R13: ffff8b8837d1a248 R14: ffff8b8838555980 R15: 
ffff8b883bf64810
[  213.092307] FS:  00007facf85b8700(0000) GS:ffff8b883fc00000(0000) knlGS:
0000000000000000
[  213.092307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  213.092307] CR2: 0000000000000000 CR3: 000000007845e002 CR4: 
00000000003606f0
[  213.092307] Call Trace:
[  213.092307]  ? shash_ahash_digest+0xd0/0xd0
[  213.092307]  shash_async_digest+0x24/0x30
[  213.092307]  crypto_ahash_op+0x29/0x70
[  213.092307]  crypto_ahash_digest+0x16/0x20
[  213.092307]  crypto_authenc_genicv+0x7b/0xb0 [authenc]
[  213.092307]  ? simd_skcipher_encrypt+0xb7/0xc0
[  213.092307]  crypto_authenc_encrypt+0xa3/0x170 [authenc]
[  213.092307]  aead_recvmsg+0x2dd/0x5f0 [algif_aead]
[  213.092307]  sock_recvmsg+0x3d/0x50
[  213.092307]  sock_read_iter+0x86/0xc0
[  213.092307]  __vfs_read+0xcb/0x120
[  213.092307]  vfs_read+0x8e/0x130
[  213.092307]  SyS_read+0x46/0xa0
[  213.092307]  do_syscall_64+0x5f/0xf0
[  213.092307]  entry_SYSCALL64_slow_path+0x25/0x25
[  213.092307] RIP: 0033:0x7facf7ec41b0
[  213.092307] RSP: 002b:00007ffff79f22b8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[  213.092307] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007facf7ec41b0
[  213.092307] RDX: 0000000000001000 RSI: 00007ffff79f33c0 RDI: 
0000000000000006
[  213.092307] RBP: 0000000001ad701c R08: 0000000000000000 R09: 
00007ffff79f2250
[  213.092307] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[  213.092307] R13: 00007ffff79f33c0 R14: 00007ffff79f33c0 R15: 
00007ffff79f23c0
[  213.092307] Code: 03 35 14 0e a4 00 48 01 fe 4c 89 e7 e8 71 fa ff ff 41 89 
c5 41 83 ae c0 08 00 00 01 41 f6 44 24 09 02 74 92 e8 79 6f 42 00 eb 8b <0f> 
0b 0f 0b 0f 1f 00 0f 1f 44 00 00 48 8b 47 20 55 48 8d 77 50 
[  213.092307] RIP: shash_ahash_digest+0xc9/0xd0 RSP: ffff9dbe4059bc38
[  213.125048] ---[ end trace 7b80ad4517eb7967 ]---

Ciao
Stephan
