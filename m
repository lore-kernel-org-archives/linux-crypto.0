From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 07 Oct 2017 05:21:38 +0200
Message-ID: <4036185.N3O6K43VGH@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <2010633.8rTN3NahbQ@positron.chronox.de> <20171007030752.GA29495@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34728 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbdJGDVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 23:21:43 -0400
In-Reply-To: <20171007030752.GA29495@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 7. Oktober 2017, 05:07:52 CEST schrieb Herbert Xu:

Hi Herbert,

> On Sat, Oct 07, 2017 at 04:53:46AM +0200, Stephan Müller wrote:
> > I use authenc(hmac(sha256),cbc(aes)) which in turn uses cbc-aes-aesni on
> > my
> > system.
> 
> So where exactly is it crashing in cbc-aes-aesni? AFAICS it should
> handle the zero case just fine.  Or is it hmac that's crashing as
> your other patch suggested?

The bug happens with the following invocation sequence:

setsockopt(3, SOL_ALG, 5, NULL, 1)      = -1 EBUSY (Device or resource busy)
sendmsg(6, {msg_name=NULL, msg_namelen=0, msg_iov=NULL, msg_iovlen=0, 
msg_control=[{cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x3}, {cmsg_len=40, 
cmsg_level=SOL_ALG, cmsg_type=0x2}, {cmsg_len=20, cmsg_level=SOL_ALG, 
cmsg_type=0x4}], msg_controllen=88, msg_flags=0}, MSG_MORE) = 0
vmsplice(5, [{iov_base="V", iov_len=1}], 1, SPLICE_F_GIFT) = 1
splice(4, NULL, 6, NULL, 1, 0)          = 1
read(6,  <unfinished ...>)              = ?
+++ killed by SIGKILL +++

The kernel reports the following crash:

[135385.003653] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000010
[135385.004007] IP: skcipher_walk_skcipher+0x18/0xb0
[135385.004007] PGD 7bbf4067 P4D 7bbf4067 PUD 784a6067 PMD 0 
[135385.004007] Oops: 0000 [#1] SMP
[135385.004007] Modules linked in: authenc algif_aead algif_rng algif_skcipher 
crypto_user algif_hash af_alg ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
nf_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc 
ip6table_mangle ip6table_raw ip6table_security iptable_mangle iptable_raw 
iptable_security ebtable_filter ebtables ip6table_filter ip6_tables 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel virtio_net virtio_balloon 
pcspkr i2c_piix4 sch_fq_codel virtio_blk virtio_console virtio_pci 
crc32c_intel virtio_ring serio_raw virtio
[135385.004007] CPU: 3 PID: 1148 Comm: lt-kcapi Not tainted 4.14.0-rc1+ #554
[135385.004007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.10.2-1.fc26 04/01/2014
[135385.004007] task: ffff976fb9380d40 task.stack: ffff9fd280e24000
[135385.004007] RIP: 0010:skcipher_walk_skcipher+0x18/0xb0
[135385.004007] RSP: 0018:ffff9fd280e27ba0 EFLAGS: 00010246
[135385.004007] RAX: 0000000000000000 RBX: ffff9fd280e27be0 RCX: 
0000000000000000
[135385.004007] RDX: ffff976fb85a5428 RSI: ffff976f76330d08 RDI: 
ffff9fd280e27be0
[135385.004007] RBP: ffff9fd280e27bc0 R08: 0000000087654321 R09: 
ffff976fb842b880
[135385.004007] R10: ffff9fd280e27cb8 R11: 0000000000000000 R12: 
0000000000000001
[135385.004007] R13: ffff976f76330d08 R14: ffff976fb842b800 R15: 
0000000000000000
[135385.004007] FS:  00007fcb922bb700(0000) GS:ffff976fbfd80000(0000) knlGS:
0000000000000000
[135385.004007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[135385.004007] CR2: 0000000000000010 CR3: 00000000798c4001 CR4: 
00000000003606e0
[135385.004007] Call Trace:
[135385.004007]  ? skcipher_walk_virt+0x1e/0x40
[135385.004007]  cbc_encrypt+0x3e/0xc0
[135385.004007]  ? skcipher_null_crypt+0x64/0x80
[135385.004007]  simd_skcipher_encrypt+0xb7/0xc0
[135385.004007]  ? simd_skcipher_encrypt+0xb7/0xc0
[135385.004007]  crypto_authenc_encrypt+0x94/0x170 [authenc]
[135385.004007]  aead_recvmsg+0x2dd/0x5f0 [algif_aead]
[135385.004007]  sock_recvmsg+0x3d/0x50
[135385.004007]  sock_read_iter+0x86/0xc0
[135385.004007]  __vfs_read+0xcb/0x120
[135385.004007]  vfs_read+0x8e/0x130
[135385.004007]  SyS_read+0x46/0xa0
[135385.004007]  do_syscall_64+0x5f/0xf0
[135385.004007]  entry_SYSCALL64_slow_path+0x25/0x25
[135385.004007] RIP: 0033:0x7fcb91bc71b0
[135385.004007] RSP: 002b:00007ffe41fc2898 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[135385.004007] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007fcb91bc71b0
[135385.004007] RDX: 0000000000001000 RSI: 00007ffe41fc39a0 RDI: 
0000000000000006
[135385.004007] RBP: 00000000012f601c R08: 0000000000000001 R09: 
0000000000000000
[135385.004007] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[135385.004007] R13: 00007ffe41fc39a0 R14: 00007ffe41fc39a0 R15: 
00007ffe41fc29a0
[135385.004007] Code: ff ff ff e9 42 ff ff ff 90 66 2e 0f 1f 84 00 00 00 00 00 
0f 1f 44 00 00 48 8b 46 10 48 8b 56 40 55 8b 8f 84 00 00 00 48 89 47 20 <8b> 
40 10 48 89 e5 83 e1 ef 89 47 28 48 8b 46 18 48 89 47 38 8b 
[135385.004007] RIP: skcipher_walk_skcipher+0x18/0xb0 RSP: ffff9fd280e27ba0
[135385.004007] CR2: 0000000000000010
[135385.004007] ---[ end trace 25c44edb63da431d ]---
[135385.004007] Kernel panic - not syncing: Fatal exception
[135385.004007] Kernel Offset: 0x11000000 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffffbfffffff)
[135385.004007] ---[ end Kernel panic - not syncing: Fatal exception
> 
> Cheers,


Ciao
Stephan
